chaid_estat_classification
===========

Mustafa Hussain -- h.mustafa.mail@gmail.com

Decision trees are awesome. They are far more intuitive, and about as accurate, as logistic regression models. The catch is that STATA does not currently support them as well as logistic regressions. 

Joseph Luchman created the `chaid` function for STATA in 2014, which creates decision trees. However, logistic models are still better supported -- they can be validated on out-of-sample datasets using the `estat classification` function.

That's where `chaid_estat_classification` comes in. It provides the ability to test decision trees on any dataset, after creating the tree.

Please note that, although I have validated this code against a small example of predicting a binary variable, it has not been rigorously tested.

Copyright for all code in this repository: CC BY-NC 4.0 (https://creativecommons.org/licenses/by-nc/4.0/)
