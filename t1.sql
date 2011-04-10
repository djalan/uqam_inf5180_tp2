------------------------------
------------------------------
-- Incrementation automatique
------------------------------
------------------------------
INSERT INTO Client (motDePasse, nom, prenom, plusGrandeQualite, telephone)
VALUES('mdp', 'Sirois', 'Alain', 'connard', '5144359111')
/
INSERT INTO Client (motDePasse, nom, prenom, plusGrandeQualite, telephone)
VALUES('mdp', 'Woww', 'Roland', 'good', '1234567899')
/
SELECT *
FROM Client
/



INSERT INTO Fournisseur (motDePasse, raisonSociale, telephone)
VALUES('mdp', 'Chanter', '5144359111')
/
INSERT INTO Fournisseur (motDePasse, raisonSociale, telephone)
VALUES('mdp', 'Rire', '5144359111')
/
SELECT *
FROM Fournisseur
/



INSERT INTO Commande (dateCommande, annulee, noClient)
VALUES('2011/04/02', 0, 1)
/
INSERT INTO Commande (dateCommande, annulee, noClient)
VALUES('2011/04/22', 0, 2)
/
SELECT *
FROM Commande
/



----------------------
-- Creation de donnees
----------------------
INSERT INTO Produit (noProduit, description, quantite, quantiteMinimum)
VALUES(1, 'bouteille de vodka', 40, 10)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11111, 1, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11112, 1, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11113, 1, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11114, 1, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11115, 1, 0)
/
INSERT INTO Produit (noProduit, description, quantite, quantiteMinimum)
VALUES(2, 'Chaises', 20, 5)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(22221, 2, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(22222, 2, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(22223, 2, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(22224, 2, 0)
/
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(22225, 2, 0)
/
SELECT	*
FROM	Produit
/
SELECT	*
FROM	Item
/
INSERT INTO LigneCommande (noCommande, noProduit, quantite, qteRestante, prixVente)
VALUES(1, 1, 50, 50, 0)
/
SELECT	*
FROM	LigneCommande
/



-- Trigger  1: Reduire quantite en stock des produits
-- Trigger 5d: Reduire quantite restante de la commande 
SELECT	*
FROM	LigneCommande
/
SELECT	*
FROM	Produit
/
INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/11/22', '2011/11/30', 100, 0, 100)
/
INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/01/04', '2011/11/30', 200, 0, 200)
/
SELECT *
FROM FactureLivraison
/
INSERT INTO LigneLivraison (noProduit, noCommande, noLivraison, qteLivraison)
VALUES(1, 1, 1, 2)
/
SELECT	*
FROM	LigneLivraison
/
SELECT	*
FROM	LigneCommande
/
SELECT	*
FROM	Produit
/





-- Trigger 2: quantite a livrer superieure a quantite en STOCK
-- ERREUR
INSERT INTO LigneLivraison (noProduit, noCommande, noLivraison, qteLivraison)
VALUES(1, 1, 1, 41)
/



-- Trigger 3: quantite a livrer superieure a quantite en COMMANDE
-- ERREUR
INSERT INTO LigneLivraison (noProduit, noCommande, noLivraison, qteLivraison)
VALUES(1, 1, 1, 51)
/



-- Trigger 4a: Le montant du paiement excede le solde restant - Carte de credit
-- ERREUR
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1235', 'VISA', '2011/11/11', 1000, 1)
/

-- Trigger 4b: Le montant du paiement excede le solde restant - Cheque
-- ERREUR
INSERT INTO PaiementCheque (noCheque, banque, datePaiement, montant, noLivraison)
VALUES('54321', 'Desjardins', '2011/11/11', 2000, 1)
/



-- Trigger 5a - Paiement carte de credit autorise
-- Tester les 3 types de cartes
SELECT	*
FROM	FactureLivraison
/
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1235', 'VISA', '2011/11/11', 10, 1)
/
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1236', 'Master Card', '2011/11/11', 10, 1)
/
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1237', 'American Express', '2011/11/11', 10, 1)
/
-- Trigger 5b - Paiement cheque
INSERT INTO PaiementCheque (noCheque, banque, datePaiement, montant, noLivraison)
VALUES('54321', 'Desjardins', '2011/11/11', 10, 1)
/
SELECT *
FROM PaiementCarteCredit
/
SELECT *
FROM PaiementCheque
/
SELECT	*
FROM	FactureLivraison
/



-- Trigger 5c: ChangerFacturePourPayer - Il reste 60$ a payer (100 - (4 x 10))
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1238', 'American Express', '2011/11/11', 60, 1)
/
SELECT *
FROM PaiementCarteCredit
/
SELECT	*
FROM	FactureLivraison
/



-- Creation de donnes
-- INSERTIONS QUI MARCHENT
INSERT INTO ItemLivraison (codeZebre, noProduit, noCommande, noLivraison)
VALUES(11111, 1, 1, 1)
/
INSERT INTO Catalogue (noProduit, date, prix)
VALUES (1, '2011/04/04', 14.99)
/
INSERT INTO Priorite (noFournisseur, noProduit, priorite)
VALUES (1, 1, 10)
/
INSERT INTO Adresse (noClient, noFournisseur, numeroCivique, rue, ville, pays, codePostal)
VALUES (1, 0, 213, 'Octave', 'Boucherville', 'Canada', 'J4B2N4')
/
-- Annule = 1     annulee = 0 deja testee en haut
INSERT INTO Commande (dateCommande, annulee, noClient)
VALUES('2011/05/25', 1, 2)
/
-- dejaLivre = 1      = 0  deja testee
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(11, 2, 1)
/


---------------
-- CHECK
---------------
--CHECK (prix >= 0)
INSERT INTO Catalogue (noProduit, dateCatalogue, prix)
VALUES (1, '2011/04/04', -10)
/

--CHECK (annulee IN(0, 1)),
INSERT INTO Commande (dateCommande, annulee, noClient)
VALUES('2011/05/25', 2, 2)
/

--CHECK (codeZebre >= 0) - Table item
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(-1, 2, 0)
/

--CHECK (dejaLivre IN(0, 1)),
INSERT INTO Item (codeZebre, noProduit, dejaLivre)
VALUES(111342, 2, 2)
/

--CHECK (quantite > 0),
INSERT INTO LigneCommande (noCommande, noProduit, quantite, qteRestante, prixVente)
VALUES(1, 2, 0, 0, 10)
/

--CHECK (payee IN(0 ,1)),
INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/02/09', '2012/11/30', 200, 2, 200)
/

--CHECK (qteLivraison > 0),
INSERT INTO LigneLivraison (noProduit, noCommande, noLivraison, qteLivraison)
VALUES(1, 1, 1, 0)
/

-- CHECK (typeDeCarte IN ('VISA', 'Master Card', 'American Express'))
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1234', 'FAILURE', '2011/11/11', 10, 2)
/



-- Delete
DROP TABLE Catalogue
/
DROP TABLE Priorite
/
DROP TABLE Fournisseur
/
DROP TABLE PaiementCheque
/
DROP TABLE PaiementCarteCredit
/
DROP TABLE ItemLivraison
/
DROP TABLE LigneLivraison
/
DROP TABLE FactureLivraison
/
DROP TABLE LigneCommande
/
DROP TABLE Item
/
DROP TABLE Produit
/
DROP TABLE Commande
/
DROP TABLE Client
/
DROP TABLE Adresse
/
