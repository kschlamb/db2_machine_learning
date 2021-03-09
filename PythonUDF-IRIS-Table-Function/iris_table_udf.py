import nzae
import numpy as np
from joblib import load
from sklearn.tree import DecisionTreeClassifier

class predict_iris_species(nzae.Ae):

    # As part of initialization, load the saved model and the target class
    # (species) names.
    def _setup(self):
        self.model = load('/home/db2inst1/db2_machine_learning/PythonUDF-IRIS-Table-Function/iris_decision_tree_model.bin')
        self.targets = load('/home/db2inst1/db2_machine_learning/PythonUDF-IRIS-Table-Function/iris_target_names.bin')

    # Main method for the Db2 UDF.
    def _getFunctionResult(self, row):

        # The input row is provided as a list (e.g. [1.0, 2.0, 3.0, 4.0]),
        # which needs to be converted into a 2D array before calling the
        # model's predict() and predict_proba() methods.

        # Find the predicted species name. Note that the result of predict()
        # is a 1D array containing the class ID (so it must be dereferenced
        # to get the class ID as a simple integer).

        row_array = np.array(row).reshape(1, -1)
        predict_class_id = self.model.predict(row_array)[0]
        predict_class_name = self.targets[predict_class_id]

        # Find the probability associated with the prediction. predict_proba()
        # returns a 2D array, with one row containing all of the probabilities
        # for the 3 different classes/species.

        predict_probability = self.model.predict_proba(row_array)[0][predict_class_id]

        # This user-define table function returns two columns:
        #  - predicted species name
        #  - probability associated with the prediction

        return(predict_class_name, predict_probability)

predict_iris_species.run()
