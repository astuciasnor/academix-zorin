print("Olá do Python 3.12 no Zorin OS Lite!")
print("Seu ambiente Python está pronto para programar.")

import pandas as pd
import matplotlib.pyplot as plt

# Exemplo de uso do pandas
data = {'Fruits': ['Apple', 'Orange', 'Banana', 'Grape'],
        'Amount': [4, 1, 2, 7]}
df = pd.DataFrame(data)
print("\nDataFrame de exemplo:")
print(df)

# Você pode descomentar as linhas abaixo para gerar um gráfico:
# plt.bar(df['Fruits'], df['Amount'], color='skyblue')
# plt.title('Quantidade de Frutas')
# plt.xlabel('Frutas')
# plt.ylabel('Quantidade')
# plt.show()
