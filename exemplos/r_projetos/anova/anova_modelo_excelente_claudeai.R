# ANOVA COMPLETA EM R - VERSÃO FINAL PARA ARTIGOS CIENTÍFICOS
# =============================================================

# Carregando pacotes necessários
if (!require(car)) install.packages("car")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(nortest)) install.packages("nortest")
if (!require(agricolae)) install.packages("agricolae")

library(car)
library(ggplot2)
library(dplyr)
library(nortest)
library(agricolae)

# 1. CRIANDO DADOS DE EXEMPLO
# ===========================
set.seed(123)
n_por_grupo <- 15
grupos <- rep(c("Grupo_A", "Grupo_B", "Grupo_C", "Grupo_D"), each = n_por_grupo)
valores <- c(
  rnorm(n_por_grupo, mean = 25, sd = 4),  # Grupo A
  rnorm(n_por_grupo, mean = 30, sd = 4),  # Grupo B
  rnorm(n_por_grupo, mean = 28, sd = 4),  # Grupo C
  rnorm(n_por_grupo, mean = 35, sd = 4)   # Grupo D
)

dados <- data.frame(
  grupo = factor(grupos),
  valor = valores
)

# Visualizando os dados
head(dados)
str(dados)

# 2. ANÁLISE EXPLORATÓRIA
# =======================

# Estatísticas descritivas por grupo
estatisticas <- dados %>%
  group_by(grupo) %>%
  summarise(
    n = n(),
    media = mean(valor),
    mediana = median(valor),
    desvio_padrao = sd(valor),
    variancia = var(valor),
    minimo = min(valor),
    maximo = max(valor),
    .groups = 'drop'
  )

print("Estatísticas Descritivas por Grupo:")
print(estatisticas)

# 3. VISUALIZAÇÕES EXPLORATÓRIAS
# ==============================

# Boxplot
p1 <- ggplot(dados, aes(x = grupo, y = valor, fill = grupo)) +
  geom_boxplot() +
  geom_jitter(width = 0.1, alpha = 0.6) +
  labs(title = "Boxplot dos Valores por Grupo",
       x = "Grupo", y = "Valor") +
  theme_minimal()

print(p1)

# Gráfico de densidade
p2 <- ggplot(dados, aes(x = valor, fill = grupo)) +
  geom_density(alpha = 0.6) +
  facet_wrap(~grupo) +
  labs(title = "Distribuição dos Valores por Grupo",
       x = "Valor", y = "Densidade") +
  theme_minimal()

print(p2)

# 4. VERIFICAÇÃO DOS PRESSUPOSTOS DA ANOVA
# ========================================

print("=== VERIFICAÇÃO DOS PRESSUPOSTOS ===")

# 4.1 Normalidade dos resíduos
modelo_anova <- aov(valor ~ grupo, data = dados)
residuos <- residuals(modelo_anova)

# Teste de Shapiro-Wilk
shapiro_test <- shapiro.test(residuos)
print("Teste de Shapiro-Wilk para normalidade dos resíduos:")
print(shapiro_test)

# Teste de Anderson-Darling
ad_test <- ad.test(residuos)
print("Teste de Anderson-Darling para normalidade:")
print(ad_test)

# Q-Q plot dos resíduos com envelope de confiança
car::qqPlot(residuos, main = "Q-Q Plot dos Resíduos com Envelope de Confiança",
            xlab = "Quantis Teóricos", ylab = "Quantis Amostrais",
            col = "blue", pch = 16, cex = 0.8)

# 4.2 Homocedasticidade (homogeneidade das variâncias)

# Teste de Levene
levene_test <- leveneTest(valor ~ grupo, data = dados)
print("Teste de Levene para homogeneidade das variâncias:")
print(levene_test)

# Teste de Bartlett
bartlett_test <- bartlett.test(valor ~ grupo, data = dados)
print("Teste de Bartlett para homogeneidade das variâncias:")
print(bartlett_test)

# Gráfico de resíduos vs valores ajustados
plot(fitted(modelo_anova), residuos,
     main = "Resíduos vs Valores Ajustados",
     xlab = "Valores Ajustados", ylab = "Resíduos")
abline(h = 0, col = "red", lty = 2)

# 5. ANOVA PROPRIAMENTE DITA
# ==========================

print("=== RESULTADOS DA ANOVA ===")

# ANOVA
resultado_anova <- summary(modelo_anova)
print(resultado_anova)

# Estatísticas adicionais
print("Média geral:")
print(mean(dados$valor))

print("Soma dos quadrados:")
print(paste("SQ Total:", sum((dados$valor - mean(dados$valor))^2)))
print(paste("SQ Entre grupos:", sum(modelo_anova$fitted.values - mean(dados$valor))^2))
print(paste("SQ Dentro dos grupos:", sum(residuos^2)))

# 6. TESTES POST-HOC (se ANOVA for significativa)
# ===============================================

alpha <- 0.05
p_valor_anova <- resultado_anova[[1]][1, "Pr(>F)"]

if (p_valor_anova < alpha) {
  print("=== TESTES POST-HOC ===")
  print("ANOVA significativa. Realizando testes post-hoc...")
  
  # Teste de Tukey HSD
  tukey_test <- TukeyHSD(modelo_anova)
  print("Teste de Tukey HSD:")
  print(tukey_test)
  
  # Visualização do teste de Tukey
  par(mar = c(5, 8, 4, 2))  # Ajustar margens para nomes longos
  plot(tukey_test, las = 1, cex.axis = 0.8)
  title(main = "Intervalos de Confiança - Teste de Tukey", line = 2.5)
  
  # Teste de Duncan (usando agricolae)
  duncan_test <- duncan.test(modelo_anova, "grupo", alpha = alpha)
  print("Teste de Duncan:")
  print(duncan_test)
  
  # Teste de Bonferroni
  pairwise_t <- pairwise.t.test(dados$valor, dados$grupo, 
                                p.adjust.method = "bonferroni")
  print("Teste t pareado com correção de Bonferroni:")
  print(pairwise_t)
  
} else {
  print("ANOVA não significativa. Não há evidência de diferenças entre os grupos.")
}

# 7. MEDIDAS DE TAMANHO DO EFEITO
# ===============================

# Eta quadrado
SS_total <- sum((dados$valor - mean(dados$valor))^2)
SS_between <- sum((fitted(modelo_anova) - mean(dados$valor))^2)
eta_squared <- SS_between / SS_total

print("=== TAMANHO DO EFEITO ===")
print(paste("Eta quadrado:", round(eta_squared, 4)))

# Interpretação do eta quadrado
if (eta_squared < 0.01) {
  interpretacao <- "pequeno"
} else if (eta_squared < 0.06) {
  interpretacao <- "médio"
} else {
  interpretacao <- "grande"
}

print(paste("Tamanho do efeito:", interpretacao))

# 8. GRÁFICO PRINCIPAL - PADRÃO CIENTÍFICO
# ========================================

# Preparando dados para o gráfico
medias_dados <- dados %>%
  group_by(grupo) %>%
  summarise(
    media = mean(valor),
    erro_padrao = sd(valor) / sqrt(n()),
    desvio_padrao = sd(valor),
    .groups = 'drop'
  )

# Determinando as letrinhas baseadas nos testes post-hoc
if (p_valor_anova < alpha) {
  # Se há diferenças significativas, usar resultado do teste de Tukey
  tukey_result <- TukeyHSD(modelo_anova)
  tukey_pvalues <- tukey_result$grupo[, "p adj"]
  
  # Criar uma versão ordenada dos dados
  grupos_ordenados <- medias_dados[order(medias_dados$media), ]
  
  # Inicializar coluna de letras
  grupos_ordenados$letra <- character(nrow(grupos_ordenados))
  
  # Inicializar todas as letras disponíveis
  letras_disponiveis <- letters[1:nrow(grupos_ordenados)]
  letra_atual <- 1
  
  # Atribuir letras baseado nas comparações do Tukey
  for (i in 1:nrow(grupos_ordenados)) {
    grupo_atual <- grupos_ordenados$grupo[i]
    
    if (i == 1) {
      # Primeiro grupo sempre recebe 'a'
      grupos_ordenados$letra[i] <- letras_disponiveis[letra_atual]
    } else {
      # Verificar se é significativamente diferente dos grupos anteriores
      eh_diferente <- TRUE
      
      for (j in 1:(i-1)) {
        grupo_comparacao <- grupos_ordenados$grupo[j]
        nome_comparacao <- paste(grupo_comparacao, grupo_atual, sep = "-")
        nome_comparacao_inv <- paste(grupo_atual, grupo_comparacao, sep = "-")
        
        if (nome_comparacao %in% names(tukey_pvalues)) {
          p_val <- tukey_pvalues[nome_comparacao]
        } else if (nome_comparacao_inv %in% names(tukey_pvalues)) {
          p_val <- tukey_pvalues[nome_comparacao_inv]
        } else {
          p_val <- 1  # Se não encontrar, assumir não significativo
        }
        
        if (p_val >= alpha) {
          # Não é significativamente diferente, usar a mesma letra
          grupos_ordenados$letra[i] <- grupos_ordenados$letra[j]
          eh_diferente <- FALSE
          break
        }
      }
      
      if (eh_diferente) {
        letra_atual <- letra_atual + 1
        grupos_ordenados$letra[i] <- letras_disponiveis[letra_atual]
      }
    }
  }
  
  # Reordenar de volta para a ordem original
  medias_dados <- medias_dados %>%
    left_join(grupos_ordenados[, c("grupo", "letra")], by = "grupo")
  
} else {
  # Se não há diferenças significativas, todos os grupos recebem a mesma letra
  medias_dados$letra <- rep("a", nrow(medias_dados))
}

# Função para criar sobrescritos
criar_sobrescrito <- function(letra) {
  letras_sobresr <- c("a" = "ᵃ", "b" = "ᵇ", "c" = "ᶜ", "d" = "ᵈ", "e" = "ᵉ", 
                      "f" = "ᶠ", "g" = "ᵍ", "h" = "ʰ", "i" = "ⁱ", "j" = "ʲ",
                      "k" = "ᵏ", "l" = "ˡ", "m" = "ᵐ", "n" = "ⁿ", "o" = "ᵒ",
                      "p" = "ᵖ", "q" = "ᵠ", "r" = "ʳ", "s" = "ˢ", "t" = "ᵗ",
                      "u" = "ᵘ", "v" = "ᵛ", "w" = "ʷ", "x" = "ˣ", "y" = "ʸ", "z" = "ᶻ")
  return(letras_sobresr[letra])
}

# Criar labels no formato científico: média^letra ± DP
medias_dados$label_cientifico <- paste0(
  round(medias_dados$media, 1),
  "**", criar_sobrescrito(medias_dados$letra), "**",
  " ± ", 
  round(medias_dados$desvio_padrao, 1)
)

# GRÁFICO DE BARRAS ESTILO CIENTÍFICO FINAL
p_cientifico <- ggplot(medias_dados, aes(x = grupo, y = media, fill = grupo)) +
  # Barras principais
  geom_col(width = 0.7, color = "black", size = 0.8, alpha = 0.8) +
  
  # Barras de erro (EP - Erro Padrão)
  geom_errorbar(aes(ymin = media - erro_padrao, ymax = media + erro_padrao),
                width = 0.25, size = 0.8, color = "black") +
  
  # Labels científicos acima das barras de erro
  ggtext::geom_richtext(aes(label = label_cientifico, 
                            y = media + erro_padrao + max(medias_dados$media) * 0.04),
                        size = 5, 
                        fill = NA, 
                        label.color = NA,
                        label.padding = unit(c(0.1, 0.1, 0.1, 0.1), "lines")) +
  
  # Personalização estética
  scale_fill_manual(values = c("Grupo_A" = "#E74C3C",   # Vermelho elegante
                               "Grupo_B" = "#3498DB",   # Azul
                               "Grupo_C" = "#2ECC71",   # Verde
                               "Grupo_D" = "#F39C12")) + # Laranja
  
  # Temas e labels
  labs(title = "Comparação entre Grupos",
       subtitle = "Barras representam média ± erro padrão. Valores: média^letra ± desvio padrão. Letras diferentes indicam diferenças significativas (p < 0.05)",
       x = "Grupos",
       y = "Valor (unidades)") +
  
  # Tema científico
  theme_classic() +
  theme(
    # Texto
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 9, hjust = 0.5, color = "gray30"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 11, color = "black"),
    axis.text.x = element_text(angle = 0),
    
    # Linhas dos eixos
    axis.line = element_line(color = "black", size = 0.8),
    axis.ticks = element_line(color = "black", size = 0.6),
    axis.ticks.length = unit(0.15, "cm"),
    
    # Remover legenda (cores já identificam os grupos)
    legend.position = "none",
    
    # Painel
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white"),
    
    # Margens
    plot.margin = margin(20, 20, 20, 20)
  ) +
  
  # Garantir que o eixo Y comece em zero e expandir para acomodar os labels
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, max(medias_dados$media + medias_dados$erro_padrao) * 1.2))

# Verificar se o pacote ggtext está instalado, se não, instalar
if (!require(ggtext)) {
  install.packages("ggtext")
  library(ggtext)
}

# Exibir o gráfico principal
print(p_cientifico)

# 9. GRÁFICO ALTERNATIVO (Pontos com DP)
# ======================================

medias_dp <- dados %>%
  group_by(grupo) %>%
  summarise(
    media = mean(valor),
    desvio_padrao = sd(valor),
    dp_inf = media - desvio_padrao,
    dp_sup = media + desvio_padrao,
    .groups = 'drop'
  )

p_pontos <- ggplot(medias_dp, aes(x = grupo, y = media, color = grupo)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = dp_inf, ymax = dp_sup), width = 0.2, size = 1) +
  scale_color_manual(values = c("Grupo_A" = "#E74C3C",
                                "Grupo_B" = "#3498DB", 
                                "Grupo_C" = "#2ECC71",
                                "Grupo_D" = "#F39C12")) +
  labs(title = "Médias com Desvio Padrão (± DP)",
       subtitle = "Pontos representam médias; barras representam ± 1 desvio padrão",
       x = "Grupo", y = "Valor Médio") +
  theme_classic() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray30"))

print(p_pontos)

# 10. RELATÓRIO FINAL
# ===================

print("=== RELATÓRIO FINAL ===")
print(paste("Número total de observações:", nrow(dados)))
print(paste("Número de grupos:", nlevels(dados$grupo)))
print(paste("F-statistic:", round(resultado_anova[[1]][1, "F value"], 3)))
print(paste("p-valor:", round(p_valor_anova, 4)))
print(paste("Eta quadrado:", round(eta_squared, 4)))

if (p_valor_anova < alpha) {
  print("CONCLUSÃO: Rejeitamos H0. Há diferenças significativas entre os grupos.")
} else {
  print("CONCLUSÃO: Não rejeitamos H0. Não há evidência de diferenças entre os grupos.")
}

# 11. TABELA RESUMO PARA ARTIGO CIENTÍFICO
# ========================================

tabela_resumo <- medias_dados %>%
  select(grupo, media, desvio_padrao, erro_padrao, letra) %>%
  mutate(
    media_dp = paste0(round(media, 2), " ± ", round(desvio_padrao, 2)),
    letra_superscr = sapply(letra, criar_sobrescrito)
  ) %>%
  select(
    Grupo = grupo,
    `Média ± DP` = media_dp,
    `Letra` = letra_superscr
  )

print("=== TABELA RESUMO PARA ARTIGO ===")
print(tabela_resumo)

# 12. INFORMAÇÕES PARA METHODS/RESULTS
# ====================================

cat("\n=== TEXTO PARA SEÇÃO METHODS ===\n")
cat("Os dados foram analisados utilizando ANOVA one-way seguida de teste post-hoc de Tukey HSD.")
cat("Os pressupostos de normalidade e homocedasticidade foram verificados através dos testes de Shapiro-Wilk e Levene, respectivamente.")
cat("O nível de significância adotado foi de α = 0.05. As análises foram realizadas no software R.\n")

cat("\n=== TEXTO PARA SEÇÃO RESULTS ===\n")
cat(paste("A ANOVA revelou diferenças significativas entre os grupos (F =", 
          round(resultado_anova[[1]][1, "F value"], 2), 
          ", p =", round(p_valor_anova, 3), 
          ", η² =", round(eta_squared, 3), ").\n"))

if (p_valor_anova < alpha) {
  cat("O teste post-hoc de Tukey identificou as seguintes diferenças entre os grupos (médias ± desvio padrão):\n")
  for (i in 1:nrow(tabela_resumo)) {
    cat(paste("- ", tabela_resumo$Grupo[i], ": ", tabela_resumo$`Média ± DP`[i], 
              " (", tabela_resumo$Letra[i], ")\n", sep = ""))
  }
  cat("Grupos com letras diferentes diferem significativamente (p < 0.05).\n")
}

print("=== SCRIPT CONCLUÍDO ===")
print("Este script está pronto para ser usado como modelo em futuras análises!")
