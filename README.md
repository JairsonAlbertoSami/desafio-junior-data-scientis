# Desafio Júnior Data Scientist

Neste repositório, temos 5 arquivos: `Analise_api.ipynb`, `Analise_python.ipynb`, `visualizacao_analise_API.ipynb`, `visualizacao_analise_Python.ipynb` e `analise_sql.sql`. Cada um desses arquivos responde a um conjunto de questões propostas para o desafio Júnior de Data Science do Rio de Janeiro. Este `README.md` orienta como executar cada arquivo de maneira que não dependa da base de dados do autor.

1. **Para executar `Analise_api.ipynb`:** 
   - Baixe o arquivo `.ipynb` e faça upload para o seu Google Drive.
   - Abra o arquivo no Google Colab.
   - Não é necessário instalar pacotes adicionais. O código foi estruturado para funcionar diretamente, e o arquivo contém comentários explicativos para cada bloco de código.

2. **Para executar `visualizacao_analise_API.ipynb`:** 
   - Baixe o arquivo `.ipynb` e faça upload para o seu Google Drive.
   - Abra o arquivo no Google Colab.
   - Assim como o anterior, não é necessário instalar pacotes adicionais. O arquivo possui comentários que explicam o funcionamento de cada bloco de código.

3. **Para executar `Analise_python.ipynb`:** 
   - Baixe o arquivo `.ipynb` e faça upload para o seu Google Drive.
   - Você precisará de uma conta no [Google Cloud Console](https://cloud.google.com/cloud-console). 
   - Crie um projeto BigQuery no Console e obtenha uma chave de API. Substitua o valor de `project_id` no código pelo seu projeto, por exemplo: `project_id = "datariojairson"`.
   - Execute o código no Google Colab. A célula com `!pip install basedosdados` pode precisar ser executada duas vezes para garantir que a instalação seja concluída corretamente. Após a instalação, o código funcionará normalmente.

4. **Para executar `visualizacao_analise_Python.ipynb`:** 
   - Baixe o arquivo `.ipynb` e faça upload para o seu Google Drive.
   - Abra o arquivo no Google Colab.
   - Siga o mesmo procedimento descrito para o `Analise_python.ipynb`, incluindo a criação de um projeto no Google Cloud Console, a obtenção da chave de API e a reinicialização da instalação do pacote, se necessário.

5. **Para executar `analise_sql.sql`:** 
   - No Google Cloud Console, acesse o seu projeto BigQuery.
   - Crie uma nova consulta e cole o código do arquivo `analise_sql.sql` dentro da interface de consultas.
   - Não é necessário alterar o código SQL; ele foi preparado para executar todas as consultas solicitadas conforme o desafio.