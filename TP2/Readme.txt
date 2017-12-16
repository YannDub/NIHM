Dubois Yann
M2IVI

Q3:

Le problème de cette méthode est que dans un premier temps, on obtient un angle
entre 0 et 180 (nous de savons pas si la droite est orienté ver sle bas ou vers le haut),
de plus, cet angle est arrondie à 10 degrès près, ce qui est déjà un grand pas.
Il aurait peut être été plus judicieux de calculer l'angle entre les droites passant
par le point.

Q4:

computeKmeansLearner se contente de calculer une liste de liste d'obersvation qu'il
passe à trainHMM.

trainHMM calcule les classes de chaque template. Pour y parvenir il utilise l'algorithme
du kmeans pour apprendre. Ensuite il passe le résultat de l'apprentissage à un
BaumWelchLearner pour entrainer encore le classifieur. Puis il retourne le HMM
avec les observations.

Q7:

On remarque qu'il n'y a pas de gros changement, voir même de temps en temps,
l'algorithme est encore un peut moins bon si le point de départ est trop proche
du point d'arrivé.

Q8:

Avec un resamplingPeriod de 40 : cercle 10 / 10, rectangle 4 / 10
Avec un resamplingPeriod de 200 : cercle 2 / 10, rectangle 7 / 10

On remarque que le resamplingPeriod influe beaucoup sur les résultats. Par exemple,
ici on voit que le rectangle est reconnu plus souvent lorsque qu'il y a moins de points.
Le cercle quand à lui est reconnu lorsqu'il y a beaucoup de points. Ce qui paraît logique
car en réalité le rectangle n'a en théorie besoin que de 4 points pour être reconnu
(c'est 4 côté) alors que le cercle, plus il y a de point, plus il sera précis. 
