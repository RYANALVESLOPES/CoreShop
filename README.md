# 🛍️ CoreShop

Um aplicativo de E-commerce moderno desenvolvido em Flutter, simulando a experiência de compra do Mercado Livre. O projeto consome dados reais via API REST e gerencia estado globalmente.

## 📱 Prints do App

| Home (Categorias & Busca) | Detalhes do Produto | Carrinho de Compras |
|:-------------------------:|:-------------------:|:-------------------:|
| | | |

## 🚀 Tecnologias Utilizadas

* **Flutter & Dart**: Framework UI.
* **Provider**: Gerenciamento de Estado (Carrinho e Produtos).
* **HTTP**: Consumo de API REST (Fake Store API).
* **Cached Network Image**: Cacheamento de imagens para performance.
* **Design System**: Interface inspirada no Mercado Livre (UI/UX).

## ✨ Funcionalidades

* 🛒 **Carrinho Inteligente**: Adicionar, remover e alterar quantidades com cálculo de total em tempo real.
* 🔍 **Busca Dinâmica**: Filtragem de produtos por nome instantaneamente.
* ⚡ **API Integration**: Dados consumidos da [FakeStoreAPI](https://fakestoreapi.com/).
* 🏷️ **Filtro por Categorias**: Navegação fluida entre eletrônicos, roupas e jóias.
* 🖼️ **Imagens Robustas**: Tratamento de erro e loading em imagens externas.

## 🛠️ Como rodar o projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/RYANALVESLOPES/CoreShop.git](https://github.com/RYANALVESLOPES/CoreShop.git)

2. Instale as dependências:

        flutter pub get

3. Execute o App:

        flutter run
        
Desenvolvido por Ryan Lopes 🚀