# db2_machine_learning
Scripts and code related to the use of machine learning with Db2 11.5 for Linux, UNIX, and Windows. This includes Db2's built-in ML capabilities as well as integration with 3rd party applications.

**Samples:**
- **AutoAI:** Samples related to IBM Watson Studio's AutoAI feature.
- **Sample_Db2_Python_UDFs:** Sample Db2 Python UDFs. Not necessarily ML-related.
- **PythonUDF-PreBuiltModel-IRIS:** Loads an exported scikit-learn decision tree model into a Db2 Python UDF.
- **PythonUDF-PreBuiltModel-IRIS-with-Trigger:** Creates a Db2 Python UDF with an existing scikit-learn model. Uses a trigger to perform automatic inferencing when new data inserted into a table.
- **PythonUDF-IRIS-Table-Function:** Creates a user-defined table function in Python that returns both the species name and the probability.
- **Db2_ML-Linear_Reg-CRICKET_CHIRPS:** Uses Db2's built-in ML procedures to train a linear regression model and use it for scoring. Includes MAE/MSE evaluation.
- **Db2_ML-Linear_Reg-ABALONE:** Uses Db2's built-in ML procedures to train a linear regression model and use it for scoring. Includes MAE/MSE evaluation.
- **Db2_ML-Decision_Tree-IRIS:** Uses Db2's built-in ML procedures to train a decision tree model and use it for scoring.
- **Db2_ML-Decision_Tree-TITANIC:** Uses Db2's built-in ML procedures to train a decision tree model and use it for scoring. Also calculates accuracy, precision, and recall.
- **Db2_ML-Naive_Bayes-IRIS:** Uses Db2's built-in ML procedures to train a Naive Bayes classifier and use it for scoring.

Db2 integration with **H2O Driverless AI** (e.g. in-database scoring with Python MOJO and standalone scoring pipelines) can be found here: https://github.com/kschlamb/h2o_driverless_ai.
