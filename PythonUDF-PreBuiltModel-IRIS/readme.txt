======================================================================

For RHEL 7.6 on Power, the following commands are needed to setup the
environment. Equivalents exist for other Linux flavours.

   sudo yum install -y openblas-devel
   sudo yum install -y gcc-gfortran
   pip install joblib
   pip install sklearn

Other binaries and packages may be needed, but I would have installed
them previously for other purposes and so I'm not sure exactly what
they are.

======================================================================

The file "iris_decision_tree_model.bin" contains a simple decision
tree model built using Scikit-learn (using a Jupyter Notebook on
Windows 10). The model and target names were exported to disk using
the dump method from the joblib package:

   dump(tree_model, 'iris_decision_tree_model.bin')
   dump(iris.target_names, 'iris_decision_tree_model.bin')

======================================================================
