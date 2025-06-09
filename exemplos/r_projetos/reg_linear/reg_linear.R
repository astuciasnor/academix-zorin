# Análise de Regressão Linear Completa
# Autor: Script automatizado
# Data: 2025

# Carregar pacotes necessários
library(tidyverse)
library(ggplot2)
library(broom)
library(ggpubr)
library(ggrepel)
library(scales)
library(gridExtra)
library(knitr)
library(kableExtra)
library(car)
library(lmtest)
library(nortest)

# Definir tema customizado para gráficos
theme_regression <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      legend.position = "bottom",
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

# Gerar dados de exemplo (substitua com seus próprios dados)
set.seed(123)
n <- 100
x <- rnorm(n, mean = 50, sd = 10)
y <- 2.5 * x + rnorm(n, mean = 0, sd = 15) + 10

# Criar dataframe
dados <- data.frame(x = x, y = y)

# Realizar regressão linear
modelo <- lm(y ~ x, data = dados)

# Extrair informações do modelo
resumo_modelo <- summary(modelo)
modelo_tidy <- tidy(modelo)
modelo_glance <- glance(modelo)
modelo_augment <- augment(modelo)

# Extrair estatísticas principais
r_squared <- modelo_glance$r.squared
adj_r_squared <- modelo_glance$adj.r.squared
p_value <- modelo_glance$p.value
n_obs <- nrow(dados)
intercept <- modelo_tidy$estimate[1]
slope <- modelo_tidy$estimate[2]
intercept_se <- modelo_tidy$std.error[1]
slope_se <- modelo_tidy$std.error[2]
intercept_p <- modelo_tidy$p.value[1]
slope_p <- modelo_tidy$p.value[2]

# Criar equação da regressão
equacao <- sprintf("y = %.2f + %.2f × x", intercept, slope)

# Gráfico 1: Scatter plot com linha de regressão e intervalo de confiança
p1 <- ggplot(dados, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.6, color = "steelblue") +
  geom_smooth(method = "lm", se = TRUE, color = "darkred", fill = "pink", alpha = 0.2) +
  geom_text(x = min(dados$x), y = max(dados$y), 
            label = paste0(equacao, "\n",
                          "R² = ", round(r_squared, 3), "\n",
                          "n = ", n_obs, "\n",
                          "p < ", ifelse(p_value < 0.001, "0.001", round(p_value, 3))),
            hjust = 0, vjust = 1, size = 4, color = "black",
            bg = "white", label.r = unit(0.2, "lines"),
            label.padding = unit(0.3, "lines")) +
  labs(title = "Regressão Linear",
       subtitle = "Dados observados e linha de regressão ajustada",
       x = "Variável Independente (X)",
       y = "Variável Dependente (Y)") +
  theme_regression()

# Gráfico 2: Resíduos vs Valores Ajustados
p2 <- ggplot(modelo_augment, aes(x = .fitted, y = .resid)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red", size = 1) +
  geom_point(size = 3, alpha = 0.6, color = "darkgreen") +
  geom_smooth(method = "loess", se = TRUE, color = "blue", size = 0.8) +
  labs(title = "Análise de Resíduos",
       subtitle = "Resíduos vs Valores Ajustados",
       x = "Valores Ajustados",
       y = "Resíduos") +
  theme_regression()

# Gráfico 3: Q-Q Plot para normalidade dos resíduos
p3 <- ggplot(modelo_augment, aes(sample = .resid)) +
  stat_qq(size = 3, alpha = 0.6, color = "purple") +
  stat_qq_line(color = "red", size = 1) +
  labs(title = "Gráfico Q-Q",
       subtitle = "Verificação da normalidade dos resíduos",
       x = "Quantis Teóricos",
       y = "Quantis Amostrais") +
  theme_regression()

# Gráfico 4: Scale-Location (Homocedasticidade)
p4 <- ggplot(modelo_augment, aes(x = .fitted, y = sqrt(abs(.std.resid)))) +
  geom_point(size = 3, alpha = 0.6, color = "orange") +
  geom_smooth(method = "loess", se = FALSE, color = "blue", size = 1) +
  labs(title = "Scale-Location",
       subtitle = "Verificação de homocedasticidade",
       x = "Valores Ajustados",
       y = "√|Resíduos Padronizados|") +
  theme_regression()

# Gráfico 5: Resíduos vs Leverage
p5 <- ggplot(modelo_augment, aes(x = .hat, y = .std.resid)) +
  geom_point(size = 3, alpha = 0.6, color = "brown") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_smooth(method = "loess", se = FALSE, color = "blue", size = 1) +
  labs(title = "Resíduos vs Leverage",
       subtitle = "Identificação de pontos influentes",
       x = "Leverage",
       y = "Resíduos Padronizados") +
  theme_regression()

# Gráfico 6: Histograma dos resíduos
p6 <- ggplot(modelo_augment, aes(x = .resid)) +
  geom_histogram(aes(y = ..density..), bins = 20, 
                 fill = "lightblue", color = "black", alpha = 0.7) +
  geom_density(color = "red", size = 1) +
  stat_function(fun = dnorm, 
                args = list(mean = mean(modelo_augment$.resid), 
                           sd = sd(modelo_augment$.resid)),
                color = "blue", size = 1, linetype = "dashed") +
  labs(title = "Distribuição dos Resíduos",
       subtitle = "Histograma com curvas de densidade",
       x = "Resíduos",
       y = "Densidade") +
  theme_regression()

# Organizar todos os gráficos em um painel
diagnostico_completo <- grid.arrange(
  p1, p2, p3, p4, p5, p6,
  ncol = 2, nrow = 3,
  top = "Diagnóstico Completo da Regressão Linear"
)

# Criar tabela de resultados estatísticos
tabela_coeficientes <- data.frame(
  Termo = c("Intercepto", "Coeficiente (x)"),
  Estimativa = c(intercept, slope),
  `Erro Padrão` = c(intercept_se, slope_se),
  `Estatística t` = modelo_tidy$statistic,
  `Valor-p` = c(intercept_p, slope_p),
  Significância = ifelse(c(intercept_p, slope_p) < 0.001, "***",
                        ifelse(c(intercept_p, slope_p) < 0.01, "**",
                              ifelse(c(intercept_p, slope_p) < 0.05, "*",
                                    ifelse(c(intercept_p, slope_p) < 0.1, ".", ""))))
)

# Estatísticas do modelo
estatisticas_modelo <- data.frame(
  Estatística = c("R²", "R² Ajustado", "Estatística F", "Valor-p (modelo)", 
                  "Graus de Liberdade", "AIC", "BIC", "Erro Padrão Residual"),
  Valor = c(
    round(r_squared, 4),
    round(adj_r_squared, 4),
    round(modelo_glance$statistic, 2),
    formatC(p_value, format = "e", digits = 3),
    paste0(modelo_glance$df, ", ", modelo_glance$df.residual),
    round(AIC(modelo), 2),
    round(BIC(modelo), 2),
    round(modelo_glance$sigma, 3)
  )
)

# Testes de diagnóstico
teste_normalidade <- shapiro.test(modelo_augment$.resid)
teste_bp <- bptest(modelo)  # Teste Breusch-Pagan para heterocedasticidade
teste_dw <- dwtest(modelo)  # Teste Durbin-Watson para autocorrelação

diagnosticos <- data.frame(
  Teste = c("Shapiro-Wilk (Normalidade)", 
            "Breusch-Pagan (Homocedasticidade)",
            "Durbin-Watson (Autocorrelação)"),
  `Estatística` = c(teste_normalidade$statistic, 
                    teste_bp$statistic, 
                    teste_dw$statistic),
  `Valor-p` = c(teste_normalidade$p.value, 
                teste_bp$p.value, 
                teste_dw$p.value),
  Interpretação = c(
    ifelse(teste_normalidade$p.value > 0.05, "Resíduos normais", "Resíduos não normais"),
    ifelse(teste_bp$p.value > 0.05, "Variância constante", "Heterocedasticidade presente"),
    ifelse(teste_dw$p.value > 0.05, "Sem autocorrelação", "Autocorrelação presente")
  )
)

# Imprimir resultados
cat("\n========== ANÁLISE DE REGRESSÃO LINEAR ==========\n\n")
cat("Equação da Regressão:\n")
cat(equacao, "\n\n")

cat("Coeficientes do Modelo:\n")
print(kable(tabela_coeficientes, digits = 4, format = "simple"))

cat("\n\nEstatísticas do Modelo:\n")
print(kable(estatisticas_modelo, format = "simple"))

cat("\n\nTestes de Diagnóstico:\n")
print(kable(diagnosticos, digits = 4, format = "simple"))

cat("\n\nInterpretação dos Resultados:\n")
cat("- O modelo explica", round(r_squared * 100, 1), "% da variabilidade em Y\n")
cat("- Para cada unidade de aumento em X, Y aumenta em média", round(slope, 3), "unidades\n")
cat("- O modelo é", ifelse(p_value < 0.05, "estatisticamente significativo", "não significativo"), 
    "ao nível de 5%\n")

# Salvar gráficos
ggsave("diagnostico_regressao_completo.png", diagnostico_completo, 
       width = 12, height = 15, dpi = 300)
ggsave("regressao_principal.png", p1, width = 8, height = 6, dpi = 300)

# Função para realizar previsões
fazer_previsao <- function(novos_x, nivel_confianca = 0.95) {
  novos_dados <- data.frame(x = novos_x)
  
  # Previsões com intervalos
  pred_intervalo <- predict(modelo, newdata = novos_dados, 
                           interval = "prediction", 
                           level = nivel_confianca)
  conf_intervalo <- predict(modelo, newdata = novos_dados, 
                           interval = "confidence", 
                           level = nivel_confianca)
  
  resultado <- data.frame(
    x = novos_x,
    y_previsto = pred_intervalo[, "fit"],
    IC_inferior = conf_intervalo[, "lwr"],
    IC_superior = conf_intervalo[, "upr"],
    IP_inferior = pred_intervalo[, "lwr"],
    IP_superior = pred_intervalo[, "upr"]
  )
  
  return(resultado)
}

# Exemplo de uso da função de previsão
novos_valores <- c(30, 40, 50, 60, 70)
previsoes <- fazer_previsao(novos_valores)

cat("\n\nPrevisões para novos valores:\n")
print(kable(previsoes, digits = 2, format = "simple"))

# Gráfico com intervalos de confiança e previsão
p_intervalos <- ggplot(dados, aes(x = x, y = y)) +
  geom_point(size = 2, alpha = 0.5, color = "gray50") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", size = 1.2) +
  geom_ribbon(data = modelo_augment, 
              aes(y = .fitted, 
                  ymin = .fitted - 1.96 * modelo_glance$sigma,
                  ymax = .fitted + 1.96 * modelo_glance$sigma),
              alpha = 0.2, fill = "blue") +
  geom_ribbon(data = modelo_augment,
              aes(y = .fitted,
                  ymin = .fitted - 1.96 * modelo_glance$sigma / sqrt(n_obs),
                  ymax = .fitted + 1.96 * modelo_glance$sigma / sqrt(n_obs)),
              alpha = 0.3, fill = "red") +
  geom_point(data = previsoes, aes(x = x, y = y_previsto), 
             color = "red", size = 4, shape = 17) +
  labs(title = "Regressão Linear com Intervalos",
       subtitle = "IC 95% (vermelho) e IP 95% (azul)",
       x = "Variável X",
       y = "Variável Y") +
  theme_regression()

print(p_intervalos)

cat("\n\n========== ANÁLISE CONCLUÍDA ==========\n")
