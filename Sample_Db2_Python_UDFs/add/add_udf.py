import nzae

class add(nzae.Ae):
    def _getFunctionResult(self, row):
        var1, var2 = row
        return var1 + var2

add.run()
