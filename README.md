# db2_machine-learning
Scripts and code related to the use of machine learning with Db2 11.5 for Linux, UNIX, and Windows. This includes built-in ML capabilities as well as integration with 3rd party applications (for example, integration with H2O Driverless AI models and scoring pipelines).

**Samples:**
- **Sample_Db2_Python_UDFs:** Sample Db2 Python UDFs. Not necessarily ML-related.
- **Db2_Built-in_ML-Linear_Regression-CRICKET_CHIRP_TEMPERATURE:** Uses Db2's built-in ML procedures to train a linear regression model and use it for scoring. Includes MAE/MSE evaluation.
- **Db2_Built-in_ML-Linear_Regression-ABALONE:** Uses Db2's built-in ML procedures to train a linear regression model and use it for scoring. Includes MAE/MSE evaluation.
- **Db2_Built-in_ML-Decision_Tree-IRIS:** Uses Db2's built-in ML procedures to train a decision tree model and use it for scoring.
- **Db2_Built-in_ML-Decision_Tree-TITANIC:** Uses Db2's built-in ML procedures to train a decision tree model and use it for scoring. Also calculates accuracy, precision, and recall.
- **Db2_Built-in_ML-Naive_Bayes-IRIS:** Uses Db2's built-in ML procedures to train a Naive Bayes classifier and use it for scoring.
- **Db2_DAI_UDF:** Embeds an H2O Driverless AI Python Mojo scoring pipeline in a Db2 11.5 User Defined Function (uses Iris dataset).
