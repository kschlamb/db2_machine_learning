import nzae
import numpy as np
import lale  # Needed?
from joblib import load

class predict_iris_species(nzae.Ae):

    # As part of initialization, load the saved model.
    def _setup(self):
        self.model = load('/home/db2inst1/db2_machine_learning/AutoAI/IRIS-LALE/autoai_iris_model_pickle.bin')

    # Main method for the Db2 UDF.
    def _getFunctionResult(self, row):

        # The input row is provided as a list (e.g. [1.0, 2.0, 3.0, 4.0],
        # which needs to be converted into a 2D array before calling the
        # model's predict() method. The result is a 1D array containing the
        # class ID (so we need to return the single class value in it).

        row_array = np.array(row).reshape(1, -1)
        predict_class = self.model.predict(row_array)
        return(predict_class[0])

predict_iris_species.run()
