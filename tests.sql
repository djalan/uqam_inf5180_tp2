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
VALUES('2011/04/02', 1, 1)
/
INSERT INTO Commande (dateCommande, annulee, noClient)
VALUES('2011/04/22', 0, 2)
/
SELECT *
FROM Commande
/



INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/01/01', '2011/01/09', 10.98, 0, 10.98)
/
INSERT INTO FactureLivraison (dateLivraison, dateLimitePaiement, sousTotal, payee, soldeRestant)
VALUES('2011/11/22', '2011/11/30', 1111.98, 0, 1111.98)
/
SELECT *
FROM FactureLivraison
/



INSERT INTO Produit
VALUES(1, 'bouteille de vodka', 40, 10)
/
SELECT *
FROM Produit
/



INSERT INTO LigneCommande
VALUES(1, 1, 20)
/
SELECT *
FROM LigneCommande
/



INSERT INTO PaiementCarteCredit
VALUES('1234', 'FAILURE', '2011/11/11', 22.43, 1)
/
INSERT INTO PaiementCarteCredit
VALUES('1235', 'VISA', '2011/11/11', 22.43, 1)
/
INSERT INTO PaiementCarteCredit
VALUES('1236', 'Master Card', '2011/11/11', 22.43, 1)
/
INSERT INTO PaiementCarteCredit
VALUES('1237', 'American Express', '2011/11/11', 22.43, 1)
/
SELECT *
FROM PaiementCarteCredit
/


-- Delete
DELETE FROM Fournisseur
/
DELETE FROM LigneCommande
/
DELETE FROM Commande
/
DELETE FROM Produit
/
DELETE FROM Client
/
DELETE FROM PaiementCarteCredit
/
DELETE FROM PaiementCarteCredit
/
DELETE FROM FactureLivraison
/
