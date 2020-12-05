import nzae

class multiply_udf(nzae.Ae):

    def _getFunctionResult(self, rows):
        num1, num2 = rows
        if num1 is None or num2 is None:
            self.userError("NULL values not allowed.")
        return num1 * num2

multiply_udf.run()
