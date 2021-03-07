import nzae
import numpy as np
from joblib import load
from sklearn.tree import DecisionTreeClassifier

class predict_iris_species(nzae.Ae):

    # As part of initialization, load the saved model and the target class
    # (species) names.
    def _setup(self):
        self.model = load('/home/db2inst1/db2_machine_learning/PythonUDF-PreBuiltModel-IRIS-with-Trigger/iris_decision_tree_model.bin')
        self.targets = load('/home/db2inst1/db2_machine_learning/PythonUDF-PreBuiltModel-IRIS-with-Trigger/iris_target_names.bin')

    # Main method for the Db2 UDF.
    def _getFunctionResult(self, row):

        # The input row is provided as a list (e.g. [1.0, 2.0, 3.0, 4.0]),
        # which needs to be converted into a 2D array before calling the
        # model's predict() method. The result is a 1D array containing the
        # class ID.

        row_array = np.array(row).reshape(1, -1)
        predict_class_id = self.model.predict(row_array)[0]

        # Return the class name.

        predict_class_name = self.targets[predict_class_id]
        return(predict_class_name)

predict_iris_species.run()
