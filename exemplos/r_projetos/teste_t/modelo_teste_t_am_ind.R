# TESTE t COMPLETO PARA DUAS AMOSTRAS INDEPENDENTES - PADRÃO CIENTÍFICO
# =====================================================================

##. Carregando pacotes necessários
if (!require(car)) install.packages("car")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(nortest)) install.packages("nortest")
if (!require(ggtext)) install.packages("ggtext")
if (!require(effsize)) install.packages("effsize")
if (!require(ggsignif)) install.packages("ggsignif")

library(car)
library(ggplot2)
library(dplyr)
library(nortest)
library(ggtext)
library(effsize)
library(ggsignif)


#. 1. CRIANDO DADOS DE EXEMPLO
# ===========================
set.seed(123)
n_por_grupo <- 20

# Criando dois grupos com diferença detectável
grupo_controle <- rnorm(n_por_grupo, mean = 22, sd = 3.5)
grupo_tratamento <- rnorm(n_por_grupo, mean = 27, sd = 3.2)

dados <- data.frame(
  grupo = factor(rep(c("Controle", "Tratamento"), each = n_por_grupo)),
  valor = c(grupo_controle, grupo_tratamento)
)

# Visualizando os dados
head(dados)
str(dados)
print(paste("Total de observações:", nrow(dados)))

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
    erro_padrao = sd(valor) / sqrt(n()),
    minimo = min(valor),
    maximo = max(valor),
    q25 = quantile(valor, 0.25),
    q75 = quantile(valor, 0.75),
    .groups = 'drop'
  )

print("=== ESTATÍSTICAS DESCRITIVAS POR GRUPO ===")
print(estatisticas)

# 3. VISUALIZAÇÕES EXPLORATÓRIAS
# ==============================

# Boxplot comparativo
p1 <- ggplot(dados, aes(x = grupo, y = valor, fill = grupo)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.1, alpha = 0.6, size = 2) +
  scale_fill_manual(values = c("Controle" = "#3498DB", "Tratamento" = "#E74C3C")) +
  labs(title = "Comparação entre Grupos",
       subtitle = "Boxplot com pontos individuais",
       x = "Grupo", y = "Valor") +
  theme_classic() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))

print(p1)

# Histogramas sobrepostos
p2 <- ggplot(dados, aes(x = valor, fill = grupo)) +
  geom_histogram(alpha = 0.6, bins = 15, position = "identity") +
  scale_fill_manual(values = c("Controle" = "#3498DB", "Tratamento" = "#E74C3C")) +
  labs(title = "Distribuição dos Valores por Grupo",
       x = "Valor", y = "Frequência", fill = "Grupo") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

print(p2)

# Gráfico de densidade
p3 <- ggplot(dados, aes(x = valor, fill = grupo)) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = c("Controle" = "#3498DB", "Tratamento" = "#E74C3C")) +
  labs(title = "Curvas de Densidade por Grupo",
       x = "Valor", y = "Densidade", fill = "Grupo") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

print(p3)

# Boxplot e densidade
p4 <- ggplot(dados, aes(x = grupo, y = valor, fill = grupo)) +
  geom_violin(alpha = 0.6, trim = FALSE) +
  geom_boxplot(width = 0.15, alpha = 0.8, outlier.shape = NA) +
  geom_jitter(width = 0.1, alpha = 0.6, size = 2) +
  scale_fill_manual(values = c("#3498DB", "#E74C3C")) +
  labs(title = "Distribuição dos Valores",
       subtitle = "Violino + Boxplot + Pontos Individuais",
       y = "Valor Medido") +
  coord_flip()

print(p4)

# 4. VERIFICAÇÃO DOS PRESSUPOSTOS
# ===============================

print("=== VERIFICAÇÃO DOS PRESSUPOSTOS ===")

# 4.1 Teste de normalidade para cada grupo
print("--- NORMALIDADE ---")

# Separar os dados por grupo
dados_controle <- dados$valor[dados$grupo == "Controle"]
dados_tratamento <- dados$valor[dados$grupo == "Tratamento"]

# Teste de Shapiro-Wilk para cada grupo
shapiro_controle <- shapiro.test(dados_controle)
shapiro_tratamento <- shapiro.test(dados_tratamento)

print("Teste de Shapiro-Wilk - Grupo Controle:")
print(shapiro_controle)

print("Teste de Shapiro-Wilk - Grupo Tratamento:")
print(shapiro_tratamento)

# Teste de Anderson-Darling
print("Teste de Anderson-Darling - Grupo Controle:")
print(ad.test(dados_controle))

print("Teste de Anderson-Darling - Grupo Tratamento:")
print(ad.test(dados_tratamento))

# Q-Q plots com envelope de confiança
par(mfrow = c(1, 2))
car::qqPlot(dados_controle, main = "Q-Q Plot - Controle",
            xlab = "Quantis Teóricos", ylab = "Quantis Amostrais",
            col = "#3498DB", pch = 16, cex = 0.8)

car::qqPlot(dados_tratamento, main = "Q-Q Plot - Tratamento",
            xlab = "Quantis Teóricos", ylab = "Quantis Amostrais",
            col = "#E74C3C", pch = 16, cex = 0.8)
par(mfrow = c(1, 1))

# 4.2 Teste de homogeneidade das variâncias
print("--- HOMOGENEIDADE DAS VARIÂNCIAS ---")

# Teste F
var_test <- var.test(dados_controle, dados_tratamento)
print("Teste F para igualdade das variâncias:")
print(var_test)

# Teste de Levene
levene_test <- leveneTest(valor ~ grupo, data = dados)
print("Teste de Levene:")
print(levene_test)

# 5. TESTE t DE STUDENT
# =====================

print("=== TESTE t DE STUDENT ===")

# Decidir qual versão do teste t usar baseado nos pressupostos
usar_welch <- var_test$p.value < 0.05  # Se variâncias são diferentes, usar Welch

if (usar_welch) {
  print("Variâncias desiguais detectadas. Usando teste t de Welch.")
  teste_t <- t.test(dados_controle, dados_tratamento, var.equal = FALSE)
} else {
  print("Variâncias iguais assumidas. Usando teste t clássico.")
  teste_t <- t.test(dados_controle, dados_tratamento, var.equal = TRUE)
}

print("Resultados do teste t:")
print(teste_t)

# 6. GRÁFICO DA DISTRIBUIÇÃO t - VISUALIZAÇÃO DIDÁTICA
# ===================================================

# Parâmetros da distribuição t
gl <- teste_t$parameter  # graus de liberdade
t_calc <- teste_t$statistic  # valor t calculado
t_critico <- qt(0.975, gl)  # valor crítico para α = 0.05 (bicaudal)

# Criar sequência de valores para a curva
x_seq <- seq(-4, 4, length.out = 1000)
y_seq <- dt(x_seq, gl)

# Criar dataframe para o gráfico
df_dist <- data.frame(x = x_seq, y = y_seq)

# Identificar áreas críticas
df_dist$regiao <- ifelse(abs(df_dist$x) >= t_critico, "crítica", "aceitação")

# Gráfico da distribuição t
p_distribuicao <- ggplot(df_dist, aes(x = x, y = y)) +
  # Curva da distribuição t
  geom_line(linewidth = 1.2, color = "black") +
  
  # Área de aceitação (centro)
  geom_area(data = subset(df_dist, regiao == "aceitação"), 
            aes(x = x, y = y), fill = "#2ECC71", alpha = 0.3) +
  
  # Áreas críticas (caudas)
  geom_area(data = subset(df_dist, x <= -t_critico), 
            aes(x = x, y = y), fill = "#E74C3C", alpha = 0.5) +
  geom_area(data = subset(df_dist, x >= t_critico), 
            aes(x = x, y = y), fill = "#E74C3C", alpha = 0.5) +
  
  # Linha vertical para o valor t calculado
  geom_vline(xintercept = t_calc, color = "#9B59B6", linewidth = 2, linetype = "solid") +
  
  # Linhas verticais para valores críticos
  geom_vline(xintercept = c(-t_critico, t_critico), 
             color = "#E67E22", linewidth = 1, linetype = "dashed") +
  
  # Anotações
  annotate("text", x = t_calc, y = max(y_seq) * 0.8, 
           label = paste0("t = ", round(t_calc, 2)), 
           color = "#9B59B6", size = 4, fontface = "bold",
           hjust = ifelse(t_calc > 0, -0.1, 1.1)) +
  
  annotate("text", x = t_critico, y = max(y_seq) * 0.4, 
           label = paste0("t crítico = ±", round(t_critico, 2)), 
           color = "#E67E22", size = 3.5, fontface = "bold", hjust = -0.1) +
  
  annotate("text", x = 0, y = max(y_seq) * 0.2, 
           label = paste0("Região de Aceitação\n(1-α) = ", round(1-0.05, 2)), 
           color = "#27AE60", size = 3, fontface = "bold") +
  
  annotate("text", x = -3, y = max(y_seq) * 0.1, 
           label = paste0("α/2 = ", round(0.05/2, 3)), 
           color = "#C0392B", size = 3, fontface = "bold") +
  
  annotate("text", x = 3, y = max(y_seq) * 0.1, 
           label = paste0("α/2 = ", round(0.05/2, 3)), 
           color = "#C0392B", size = 3, fontface = "bold") +
  
  # Título e labels
  labs(title = "Distribuição t de Student - Teste Bicaudal",
       subtitle = paste0("gl = ", round(gl, 1), " | p-valor = ", round(teste_t$p.value, 4),
                         " | ", ifelse(abs(t_calc) > t_critico, "Rejeita H₀", "Não rejeita H₀")),
       x = "Valores de t",
       y = "Densidade de Probabilidade") +
  
  # Tema
  theme_classic() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    panel.grid.minor = element_blank()
  ) +
  
  # Limites do gráfico
  xlim(-5, 5) +
  ylim(0, max(y_seq) * 1.1)

# Exibir o gráfico da distribuição
print(p_distribuicao)

# 7. MEDIDAS DE TAMANHO DO EFEITO
# ===============================

print("=== TAMANHO DO EFEITO ===")

# Cohen's d
cohens_d <- cohen.d(dados_controle, dados_tratamento)
print("Cohen's d:")
print(cohens_d)

# Interpretação do Cohen's d
d_valor <- abs(cohens_d$estimate)
if (d_valor < 0.2) {
  interpretacao_d <- "pequeno"
} else if (d_valor < 0.5) {
  interpretacao_d <- "pequeno a médio"
} else if (d_valor < 0.8) {
  interpretacao_d <- "médio a grande"
} else {
  interpretacao_d <- "grande"
}

print(paste("Interpretação do tamanho do efeito:", interpretacao_d))

# 7. GRÁFICO PRINCIPAL - PADRÃO CIENTÍFICO
# ========================================

# Preparando dados para o gráfico
medias_dados <- dados %>%
  group_by(grupo) %>%
  summarise(
    n = n(),
    media = mean(valor),
    erro_padrao = sd(valor) / sqrt(n()),
    desvio_padrao = sd(valor),
    # Calculando IC 95%
    ic_inf = media - qt(0.975, n-1) * erro_padrao,
    ic_sup = media + qt(0.975, n-1) * erro_padrao,
    .groups = 'drop'
  )

# Determinar significância para as letrinhas
alpha <- 0.05
if (teste_t$p.value < alpha) {
  medias_dados$letra <- c("a", "b")  # Diferentes
} else {
  medias_dados$letra <- c("a", "a")  # Iguais
}

# Função para criar sobrescritos
criar_sobrescrito <- function(letra) {
  letras_sobresr <- c("a" = "ᵃ", "b" = "ᵇ", "c" = "ᶜ", "d" = "ᵈ", "e" = "ᵉ")
  return(letras_sobresr[letra])
}

# Criar labels no formato científico: média^letra ± DP
medias_dados$label_cientifico <- paste0(
  round(medias_dados$media, 1),
  "<sup><b>", medias_dados$letra, "</b></sup>",
  " ± ", 
  round(medias_dados$desvio_padrao, 1)
)

# GRÁFICO DE BARRAS ESTILO CIENTÍFICO
p_cientifico <- ggplot(medias_dados, aes(x = grupo, y = media, fill = grupo)) +
  # Barras principais
  geom_col(width = 0.6, color = "black", size = 0.8, alpha = 0.8) +
  
  # Barras de erro (IC 95%)
  geom_errorbar(aes(ymin = ic_inf, ymax = ic_sup),
                width = 0.2, linewidth = 0.8, color = "black") +
  
  # Labels científicos acima das barras de erro
  ggtext::geom_richtext(aes(label = label_cientifico, 
                            y = ic_sup + max(media) * 0.05),
                        size = 4, 
                        fill = NA, 
                        label.color = NA,
                        label.padding = unit(c(0.1, 0.1, 0.1, 0.1), "lines")) +
  
  # Personalização estética
  scale_fill_manual(values = c("Controle" = "#3498DB", "Tratamento" = "#E74C3C")) +
  
  # Temas e labels
  labs(title = "Comparação entre Grupos",
       subtitle = paste0("Teste t: p = ", round(teste_t$p.value, 4), 
                         " | Cohen's d = ", round(cohens_d$estimate, 2), " (", interpretacao_d, ")",
                         "\nBarras de erro: IC 95% | Valores: média", 
                         ifelse(teste_t$p.value < alpha, " (letras diferentes = diferença significativa)", " (mesma letra = sem diferença)"),
                         " ± DP"),
       x = "Grupos",
       y = "Valor (unidades)") +
  
  # Tema científico
  theme_classic() +
  theme(
    # Texto
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray30"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 12, color = "black"),
    axis.text.x = element_text(angle = 0),
    
    # Linhas dos eixos
    axis.line = element_line(color = "black", linewidth = 0.8),
    axis.ticks = element_line(color = "black", size = 0.6),
    axis.ticks.length = unit(0.15, "cm"),
    
    # Remover legenda
    legend.position = "none",
    
    # Painel
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white"),
    
    # Margens
    plot.margin = margin(20, 20, 20, 20)
  ) +
  
  # Garantir que o eixo Y comece em zero
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, max(medias_dados$ic_sup) * 1.25))

# Exibir o gráfico principal
print(p_cientifico)

# 7. MEDIDAS DE TAMANHO DO EFEITO
# ===============================

print("=== TAMANHO DO EFEITO ===")

# Cohen's d
cohens_d <- cohen.d(dados_controle, dados_tratamento)
print("Cohen's d:")
print(cohens_d)

# Interpretação do Cohen's d
d_valor <- abs(cohens_d$estimate)
if (d_valor < 0.2) {
  interpretacao_d <- "pequeno"
} else if (d_valor < 0.5) {
  interpretacao_d <- "pequeno a médio"
} else if (d_valor < 0.8) {
  interpretacao_d <- "médio a grande"
} else {
  interpretacao_d <- "grande"
}

print(paste("Interpretação do tamanho do efeito:", interpretacao_d))

# 8. GRÁFICO PRINCIPAL - PADRÃO CIENTÍFICO
# =======================================

tabela_resumo <- medias_dados %>%
  left_join(estatisticas, by = "grupo") %>%
  mutate(
    media_dp = paste0(round(media.x, 2), " ± ", round(desvio_padrao.x, 2)),
    EP = erro_padrao.x,
    letra_superscr = sapply(letra, criar_sobrescrito)
  ) %>%
  select(
    Grupo = grupo,
    N = n.x,
    `Média ± DP` = media_dp,
    EP,
    `Letra` = letra_superscr
  )

print("=== TABELA RESUMO PARA ARTIGO ===")
print(tabela_resumo)

# Verificar se a tabela foi criada corretamente
if(exists("tabela_resumo")) {
  cat("\nTabela criada com sucesso!\n")
} else {
  cat("\nErro na criação da tabela. Tentando alternativa...\n")
  # Versão alternativa mais robusta
  tabela_resumo_alt <- data.frame(
    Grupo = medias_dados$grupo,
    N = medias_dados$n,
    `Média ± DP` = paste0(round(medias_dados$media, 2), " ± ", round(medias_dados$desvio_padrao, 2)),
    EP = round(medias_dados$erro_padrao, 2),
    Letra = sapply(medias_dados$letra, criar_sobrescrito),
    check.names = FALSE
  )
  print("=== TABELA ALTERNATIVA ===")
  print(tabela_resumo_alt)
}

# 10. RELATÓRIO FINAL
# ===================

print("=== RELATÓRIO FINAL ===")
print(paste("Número total de observações:", nrow(dados)))
print(paste("Tamanho dos grupos: Controle =", sum(dados$grupo == "Controle"), 
            "| Tratamento =", sum(dados$grupo == "Tratamento")))
print(paste("Estatística t:", round(teste_t$statistic, 3)))
print(paste("Graus de liberdade:", round(teste_t$parameter, 1)))
print(paste("p-valor:", round(teste_t$p.value, 4)))
print(paste("Cohen's d:", round(cohens_d$estimate, 3)))
print(paste("Intervalo de confiança da diferença:", 
            round(teste_t$conf.int[1], 2), "a", round(teste_t$conf.int[2], 2)))

# Decisão estatística
if (teste_t$p.value < alpha) {
  decisao <- "Rejeitamos H0. Há diferença significativa entre os grupos."
} else {
  decisao <- "Não rejeitamos H0. Não há evidência de diferença entre os grupos."
}

print(paste("CONCLUSÃO:", decisao))

# 11. INFORMAÇÕES PARA METHODS/RESULTS
# ====================================

cat("\n=== TEXTO PARA SEÇÃO METHODS ===\n")
cat("Os dados foram analisados utilizando teste t de Student para amostras independentes.")
cat("Os pressupostos de normalidade e homocedasticidade foram verificados através dos testes de Shapiro-Wilk e teste F, respectivamente.")
if (usar_welch) {
  cat("Devido à heterogeneidade das variâncias, foi aplicada a correção de Welch.")
}
cat("O tamanho do efeito foi calculado usando Cohen's d.")
cat("O nível de significância adotado foi de α = 0.05. As análises foram realizadas no software R.\n")

cat("\n=== TEXTO PARA SEÇÃO RESULTS ===\n")
if (usar_welch) {
  cat(paste("O teste t de Welch revelou"))
} else {
  cat(paste("O teste t de Student revelou"))
}

if (teste_t$p.value < alpha) {
  cat(paste(" diferença significativa entre os grupos (t =", round(teste_t$statistic, 2),
            ", gl =", round(teste_t$parameter, 1),
            ", p =", round(teste_t$p.value, 3),
            ", d =", round(cohens_d$estimate, 2), ").\n"))
  
  cat("As médias ± desvio padrão foram:\n")
  for (i in 1:nrow(tabela_resumo)) {
    cat(paste("- ", tabela_resumo$Grupo[i], ": ", tabela_resumo$`Média ± DP`[i], 
              " (", tabela_resumo$Letra[i], ")\n", sep = ""))
  }
} else {
  cat(paste(" ausência de diferença significativa entre os grupos (t =", round(teste_t$statistic, 2),
            ", gl =", round(teste_t$parameter, 1),
            ", p =", round(teste_t$p.value, 3),
            ", d =", round(cohens_d$estimate, 2), ").\n"))
}

print("=== SCRIPT CONCLUÍDO ===")
print("Este script está pronto para ser usado como modelo em futuras análises de teste t!")

