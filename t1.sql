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
INSERT INTO LigneCommande (noCommande, noProduit, quantite, quantiteRestante, prix)
VALUES(1, 1, 30, 30, 0)
/
SELECT	*
FROM	LigneCommande
/




-- Trigger 2: quantite a livrer superieure a quantite en STOCK
INSERT INTO LigneLivraison (noProduit, noCommande, qteLivraison)
VALUES(1, 1, 41)
/



-- Trigger 3: quantite a livrer superieure a quantite en COMMANDE
INSERT INTO LigneLivraison (noProduit, noCommande, qteLivraison)
VALUES(1, 1, 31)
/



-- Trigger  1: Reduire quantite en stock
-- Trigger 5b: Reduire quantite restante de la commande 
INSERT INTO LigneLivraison (noProduit, noCommande, qteLivraison)
VALUES(1, 1, 2)
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


INSERT INTO ItemLivraison (codeZebre, noProduit, noCommande, noLivraison)
VALUES(11111, 1, 1)
/
INSERT INTO ItemLivraison (codeZebre, noProduit, noCommande, noLivraison)
VALUES(11112, 1, 1)
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




-- Declanche CHECK
-- Le type de carte de credit n'est pas valide
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1234', 'FAILURE', '2011/11/11', 10, 1)
/



-- Trigger 4: Le montant du paiement excede le solde restant
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1235', 'VISA', '2011/11/11', 1000, 1)
/
-- Declanche trigger
INSERT INTO PaiementCheque (noCheque, banque, datePaiement, montant, noLivraison)
VALUES('54321', 'Desjardins', '2011/11/11', 2000, 2)
/



-- Tester les 3 types de cartes
-- Paiement et reduire solde
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
SELECT *
FROM PaiementCarteCredit
/
SELECT	*
FROM	FactureLivraison
/



-- Trigger 5c: ChangerFacturePourPayer
INSERT INTO PaiementCarteCredit (noCarte, typeDeCarte, datePaiement, montant, noLivraison)
VALUES('1238', 'American Express', '2011/11/11', 70, 1)
/
SELECT *
FROM PaiementCarteCredit
/
SELECT	*
FROM	FactureLivraison
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
