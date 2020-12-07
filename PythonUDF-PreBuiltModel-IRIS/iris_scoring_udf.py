import nzae
import numpy as np
from joblib import load

class predict_iris(nzae.Ae):

    # As part of initialization, load the saved model.
    def _setup(self):
        self.model = load('/home/db2inst1/db2_machine-learning/PythonUDF-PreBuiltModel-IRIS/iris_decision_tree_model.bin')

    # Main function for the Db2 UDF.
    def _getFunctionResult(self, row):

        # The input row is provided as a list (e.g. [1.0, 2.0, 3.0, 4.0],
        # which needs to be converted into a 2D array before calling the
        # model's prediction function.
        #
        # In practice, we'd want this function to return an integer
        # (class number) or a float (probability of prediction), depending
        # on the required output, but for now it's setup to return both the
        # class index and the probabilities as a string -- simply for
        # illustrative purposes.

        row_array = np.array(row).reshape(1, -1)
        predict_class_index = self.model.predict(row_array)
        predict_probabilities = self.model.predict_proba(row_array)

        result = "Class: " + str(predict_class_index[0])
        result = result + ", Prob: " + str(predict_probabilities)
        return(result)

predict_iris.run()
