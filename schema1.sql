PROMPT Creation des tables
SET ECHO ON
SPOOL OUTPUT.TXT



-- DROP TRIGGER trigger_sequence_client
-- /
-- DROP TRIGGER trigger_sequence_fournisseur
-- /
-- DROP TRIGGER trigger_sequence_commande
-- /
-- DROP TRIGGER trigger_seq_FactureLivraison
-- /
-- DROP TRIGGER ReduireQuantite
-- /
-- DROP TRIGGER BloquerInsertionSelonQuantite
-- /



DROP SEQUENCE sequence_client
/
DROP SEQUENCE sequence_fournisseur
/
DROP SEQUENCE sequence_commande
/
DROP SEQUENCE sequence_FactureLivraison
/



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



ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD'
/



CREATE TABLE Client
(noClient           INTEGER             NOT NULL,
 motDePasse         VARCHAR(20)         NOT NULL,
 nom                VARCHAR(20)         NOT NULL,
 prenom             VARCHAR(20)         NOT NULL,
 plusGrandeQualite  VARCHAR(20)         NOT NULL,
 telephone          VARCHAR(10)         NOT NULL,
 PRIMARY KEY (noClient)
)
/
CREATE TABLE Adresse
(noClient           INTEGER                 NOT NULL,
 noFournisseur      INTEGER                 NOT NULL,
 numeroCivique      INTEGER                 NOT NULL,
 rue                VARCHAR(20)             NOT NULL,
 ville              VARCHAR(20)             NOT NULL,
 pays               VARCHAR(20)             NOT NULL,
 codePostal         VARCHAR(10)             NOT NULL,
 PRIMARY KEY (noClient, noFournisseur)
)
/
CREATE TABLE Fournisseur
(noFournisseur 		INTEGER                NOT NULL,
 motDePasse    		VARCHAR(20)            NOT NULL,
 raisonSociale      VARCHAR(50)            NOT NULL,
 telephone          VARCHAR(10)            NOT NULL,
 PRIMARY KEY 	(noFournisseur)
)
/
CREATE TABLE Produit
(noProduit          INTEGER     NOT NULL,
 description        VARCHAR(30) NOT NULL,
 quantite           INTEGER     NOT NULL,
 quantiteMinimum    INTEGER     NOT NULL,
 PRIMARY KEY (noProduit)
)
/
CREATE TABLE Priorite
(noFournisseur  INTEGER         NOT NULL,
 noProduit      INTEGER         NOT NULL,
 priorite       INTEGER         NOT NULL,
 PRIMARY KEY (noFournisseur, noProduit),
 FOREIGN KEY (noFournisseur)             REFERENCES Fournisseur(noFournisseur),
 FOREIGN KEY (noProduit)                 REFERENCES Produit(noProduit)
)
/
CREATE TABLE Catalogue
(noProduit      INTEGER     NOT NULL,
 dateCatalogue  DATE        NOT NULL,
 prix           FLOAT       NOT NULL,
 PRIMARY KEY (noProduit, dateCatalogue),
 FOREIGN KEY (noProduit)                 REFERENCES Produit(noProduit)
)
/
CREATE TABLE Commande
(noCommande     INTEGER     NOT NULL,
 dateCommande   DATE        NOT NULL,
 annulee        INTEGER     NOT NULL
        CHECK (annulee IN(0, 1)),
 noClient       INTEGER     NOT NULL,
 PRIMARY KEY (noCommande),
 FOREIGN KEY (noClient) REFERENCES Client(noClient)
)
/
CREATE TABLE Item 
(codeZebre      INTEGER     NOT NULL,
 noProduit      INTEGER     NOT NULL,
 PRIMARY KEY (codeZebre),
 FOREIGN KEY (noProduit) REFERENCES Produit(noProduit)
)
/
CREATE TABLE LigneCommande 
(noProduit     INTEGER     NOT NULL,
 noCommande    INTEGER     NOT NULL,
 quantite      INTEGER     NOT NULL
        CHECK (quantite > 0),
 PRIMARY KEY (noProduit, noCommande),
 FOREIGN KEY (noProduit)              REFERENCES Produit(noProduit),
 FOREIGN KEY (noCommande)             REFERENCES Commande(noCommande)
)
/
CREATE TABLE FactureLivraison 
(noLivraison        INTEGER NOT NULL,
 dateLivraison      DATE    NOT NULL,
 dateLimitePaiement DATE    NOT NULL,
 sousTotal          FLOAT   NOT NULL,
 payee              INTEGER NOT NULL
        CHECK (payee IN(0 ,1)),
 soldeRestant       FLOAT   NOT NULL,
 PRIMARY KEY	(noLivraison)
)
/
CREATE TABLE LigneLivraison 
(noProduit      INTEGER             NOT NULL,
 noCommande     INTEGER             NOT NULL,
 noLivraison    INTEGER             NOT NULL,
 codeZebre      INTEGER             NOT NULL
        CHECK (codeZebre >= 0),
 PRIMARY KEY (noProduit, noCommande, noLivraison),
 FOREIGN KEY (noProduit, noCommande)                 REFERENCES LigneCommande(noProduit, noCommande),
 FOREIGN KEY (noLivraison)                           REFERENCES FactureLivraison(noLivraison),
 FOREIGN KEY (codeZebre)                             REFERENCES Item(codeZebre)
)
/
CREATE TABLE PaiementCheque 
(noCheque       VARCHAR(20)         NOT NULL,
 banque         VARCHAR(20)         NOT NULL,
 datePaiement   DATE                NOT NULL,
 montant        FLOAT               NOT NULL,
 noLivraison    INTEGER             NOT NULL,
 PRIMARY KEY (noCheque),
 FOREIGN KEY (noLivraison) REFERENCES FactureLivraison(noLivraison)
)
/
CREATE TABLE PaiementCarteCredit 
(noCarte       VARCHAR (20)        NOT NULL,
 typeDeCarte   VARCHAR (20)        NOT NULL
        CHECK (typeDeCarte IN ('VISA', 'Master Card', 'American Express')),
 datePaiement  DATE                NOT NULL,
 montant       FLOAT               NOT NULL,
 noLivraison   INTEGER             NOT NULL,
 PRIMARY KEY (noCarte),
 FOREIGN KEY (noLivraison) REFERENCES FactureLivraison(noLivraison)
)
/



------------------------------
------------------------------
-- Incrementation automatique
------------------------------
------------------------------
CREATE SEQUENCE sequence_client
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_client
BEFORE INSERT
ON Client
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_client.nextval INTO :NEW.noClient FROM dual;
END;
/



CREATE SEQUENCE sequence_fournisseur
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_fournisseur
BEFORE INSERT
ON Fournisseur
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_fournisseur.nextval INTO :NEW.noFournisseur FROM dual;
END;
/



CREATE SEQUENCE sequence_commande
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_commande
BEFORE INSERT
ON Commande
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_commande.nextval INTO :NEW.noCommande FROM dual;
END;
/


CREATE SEQUENCE sequence_FactureLivraison
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_seq_FactureLivraison
BEFORE INSERT
ON FactureLivraison
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_FactureLivraison.nextval INTO :NEW.noLivraison FROM dual;
END;
/


----------
-- TRIGGER
----------
------
-- 1
------
CREATE OR REPLACE TRIGGER ReduireQuantite
AFTER INSERT ON LigneCommande
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	Produit
	SET 	quantite = (quantite - :ligneApres.quantite)
	WHERE 	noProduit = :ligneApres.noProduit;
END;
/



------
-- 2
------
CREATE OR REPLACE TRIGGER BloquerQteLivreeQteEnStock
BEFORE INSERT ON LigneCommande
REFERENCING
    NEW AS ligneApres
FOR EACH ROW
DECLARE
   qtite INTEGER ;
   
BEGIN    
        SELECT Produit.quantite INTO qtite
        FROM Produit
        WHERE Produit.noProduit = :ligneApres.noProduit ;
	IF ( :ligneApres.quantite > qtite) THEN 
	 raise_application_error (-20100, 'La quantite commandee est superieure à la quantite en stock') ;

	END IF ;
END;
/

------
-- 3
------
CREATE OR REPLACE TRIGGER BloquerQteLivreeQteEnStock
BEFORE INSERT ON LigneLivraison
REFERENCING
    NEW AS ligneApres
FOR EACH ROW
DECLARE
   qtite INTEGER ;
   
BEGIN    
        SELECT Produit.quantite INTO qtite
        FROM Produit
        WHERE Produit.noProduit = :ligneApres.noProduit ;
	IF ( :ligneApres.quantite > qtite) THEN 
	 raise_application_error (-20100, 'La quantite commandee est superieure à la quantite en stock') ;

	END IF ;
END;
/


