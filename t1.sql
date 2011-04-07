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



INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/01/01', '2011/01/09', 100, 0, 100)
/
INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/11/22', '2011/11/30', 200, 0, 200)
/
SELECT *
FROM FactureLivraison
/



----------------------
-- Creation de donnees
----------------------
INSERT INTO Produit (noProduit, description, quantite, quantiteMinimum)
VALUES(1, 'bouteille de vodka', 40, 10)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(11111, 1)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(11112, 1)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(11113, 1)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(11114, 1)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(11115, 1)
/
INSERT INTO Produit (noProduit, description, quantite, quantiteMinimum)
VALUES(2, 'Chaises', 20, 5)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(22221, 2)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(22222, 2)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(22223, 2)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(22224, 2)
/
INSERT INTO Item (codeZebre, noProduit)
VALUES(22225, 2)
/
SELECT	*
FROM	Produit
/
SELECT	*
FROM	Item
/



------------------------------
------------------------------
-- Trigger: reduire quantite
------------------------------
------------------------------
-- Reduire
--
SELECT	*
FROM	Produit
/
INSERT INTO LigneCommande (noCommande, noProduit, quantite, quantiteRestante)
VALUES(1, 1, 30, 30)
/
SELECT	*
FROM	LigneCommande
/
SELECT	*
FROM	Produit
/

-- Trigger doit se declancher
--
INSERT INTO LigneCommande (noCommande, noProduit, quantite, quantiteRestante)
VALUES(2, 1, 50, 50)
/



-- Declanche CHECK
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1234', 'FAILURE', '2011/11/11', 10, 1)
/
-- Creation de 3 cartes valides
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1235', 'VISA', '2011/11/11', 10, 1)
/
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1236', 'Master Card', '2011/11/11', 10, 1)
/
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1237', 'American Express', '2011/11/11', 10, 1)
/
SELECT *
FROM PaiementCarteCredit
/



------------------------------
------------------------------
-- Trigger: reduire quantite
------------------------------
------------------------------
SELECT	*
FROM	FactureLivraison
/
-- Declanche trigger
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1235', 'VISA', '2011/11/11', 1000, 1)
/
-- Declanche trigger
INSERT INTO PaiementCheque (noCheque, banque, datePaiement, montant, noLivraison)
VALUES('54321', 'Desjardins', '2011/11/11', 2000, 2)
/






-- Delete
DELETE FROM Fournisseur
/
DELETE FROM LigneCommande
/
DELETE FROM Commande
/
DELETE FROM Item
/
DELETE FROM Produit
/
DELETE FROM Client
/
DELETE FROM PaiementCarteCredit
/
DELETE FROM PaiementCheque
/
DELETE FROM FactureLivraison
/
