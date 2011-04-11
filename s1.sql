PROMPT Creation des tables
SET ECHO ON
SET SERVEROUTPUT ON
--SPOOL output.txt



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



ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD'
/



CREATE TABLE Client
(noClient           INTEGER             NOT NULL,
 motDePasse         VARCHAR(20)         NOT NULL,
 nom                VARCHAR(20)         NOT NULL,
 prenom             VARCHAR(20)         NOT NULL,
 plusGrandeQualite  VARCHAR(20),
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
 codePostal         VARCHAR(6)              NOT NULL,
 PRIMARY KEY (noClient, noFournisseur)
)
/
CREATE TABLE Fournisseur
(noFournisseur		INTEGER		NOT NULL,
 motDePasse    		VARCHAR(20)	NOT NULL,
 raisonSociale		VARCHAR(50)	NOT NULL,
 telephone		VARCHAR(10)	NOT NULL,
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
 prix           FLOAT       NOT NULL
	CHECK (prix >= 0),
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
(codeZebre      INTEGER     NOT NULL
	CHECK (codeZebre >= 0),
 noProduit      INTEGER     NOT NULL,
 dejaLivre	INTEGER     NOT NULL
        CHECK (dejaLivre IN(0, 1)),
 PRIMARY KEY (codeZebre),
 FOREIGN KEY (noProduit) REFERENCES Produit(noProduit)
)
/
CREATE TABLE LigneCommande 
(noCommande    		INTEGER     NOT NULL,
 noProduit     		INTEGER     NOT NULL,
 quantite      		INTEGER     NOT NULL
        CHECK (quantite > 0),
 qteRestante   	INTEGER     NOT NULL,
 prixVente		FLOAT	    NOT NULL,
 PRIMARY KEY 		(noProduit, noCommande),
 FOREIGN KEY 		(noProduit)              REFERENCES Produit(noProduit),
 FOREIGN KEY 		(noCommande)             REFERENCES Commande(noCommande)
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
 qteLivraison	INTEGER		    NOT NULL
        CHECK (qteLivraison > 0),
 PRIMARY KEY (noProduit, noCommande, noLivraison),
 FOREIGN KEY (noProduit, noCommande)                 		REFERENCES LigneCommande(noProduit, noCommande),
 FOREIGN KEY (noLivraison)                           		REFERENCES FactureLivraison(noLivraison)
)
/
CREATE TABLE ItemLivraison 
(codeZebre      INTEGER             NOT NULL,
 noProduit      INTEGER             NOT NULL,
 noCommande     INTEGER             NOT NULL,
 noLivraison    INTEGER             NOT NULL,
 PRIMARY KEY (codeZebre),
 FOREIGN KEY (codeZebre)               			REFERENCES Item(codeZebre),
 FOREIGN KEY (noProduit, noCommande, noLivraison)   	REFERENCES LigneLivraison(noProduit, noCommande, noLivraison)
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



------------------------------
-- TRIGGERS
------------------------------
-- 1 Reduire la quantite en stock apres livraison
--
CREATE OR REPLACE TRIGGER ReduireQuantiteStock
AFTER INSERT ON LigneLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	Produit
	SET 	quantite = (quantite - :ligneApres.qteLivraison)
	WHERE 	noProduit = :ligneApres.noProduit;
END;
/



-- 2 Bloquer l'insertion d'une livraison d'un article
--   lorsque la quantite livree depasse la quantite en stock
--
CREATE OR REPLACE TRIGGER BloquerQteLivreeQteEnStock
BEFORE INSERT ON LigneLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	qte INTEGER;
BEGIN    
        SELECT	quantite INTO qte
        FROM	Produit
        WHERE	Produit.noProduit = :ligneApres.noProduit;

	IF (:ligneApres.qteLivraison > qte) THEN 
		raise_application_error (-20100, 'La quantite a livrer est superieure a la quantite en stock!');
	END IF;
END;
/



-- 3 Bloquer l'insertion d'une livraison d'un article quand
--   la quantite totale livree depasse la quantite
--   commandee de la commande concernee
--
CREATE OR REPLACE TRIGGER BloquerQteLivreeQteCommande
BEFORE INSERT ON LigneLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	qte INTEGER;
BEGIN    
        SELECT	qteRestante INTO qte
        FROM	LigneCommande
        WHERE	LigneCommande.noProduit = :ligneApres.noProduit AND
		LigneCommande.noCommande = :ligneApres.noCommande;

	IF (:ligneApres.qteLivraison > qte) THEN 
		raise_application_error (-20100, 'La quantite a livrer est superieure a la quantite commandee!');
	END IF;
END;
/



-- 4
-----
-- 4a Bloquer paiement carte de credit
-----
CREATE OR REPLACE TRIGGER BloquerCarteCredit
BEFORE INSERT ON PaiementCarteCredit
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	restant	INTEGER;
BEGIN
	SELECT	soldeRestant INTO restant
	FROM	FactureLivraison
	WHERE	:ligneApres.noLivraison = FactureLivraison.noLivraison;

	IF (:ligneApres.montant > restant) THEN
		raise_application_error(-20100, 'Le paiement par carte de credit depasse le montant restant a payer!');
	END IF;
END;
/
-----
-- 4b Bloquer paiement cheque
-----
CREATE OR REPLACE TRIGGER BloquerCheque
BEFORE INSERT ON PaiementCheque
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	restant	INTEGER;
BEGIN
	SELECT	soldeRestant INTO restant
	FROM	FactureLivraison
	WHERE	:ligneApres.noLivraison = FactureLivraison.noLivraison;

	IF (:ligneApres.montant > restant) THEN
		raise_application_error(-20100, 'Le paiement par cheque depasse le montant restant a payer!');
	END IF;
END;
/



---------------------
-- 5 Donnees derivees
---------------------
-- 5a
-----
CREATE OR REPLACE TRIGGER PaiementAutoriseCarteCredit
AFTER INSERT ON PaiementCarteCredit
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	FactureLivraison
	SET 	soldeRestant = (soldeRestant - :ligneApres.montant)
	WHERE 	FactureLivraison.noLivraison = :ligneApres.noLivraison;
END;
/



-----
-- 5b
-----
CREATE OR REPLACE TRIGGER PaiementAutoriseCheque
AFTER INSERT ON PaiementCheque
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	FactureLivraison
	SET 	soldeRestant = (soldeRestant - :ligneApres.montant)
	WHERE 	FactureLivraison.noLivraison = :ligneApres.noLivraison;
END;
/



-----
-- 5c
-----
CREATE OR REPLACE TRIGGER ChangerPourFacturePayee
BEFORE UPDATE ON FactureLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	IF (:ligneApres.soldeRestant = 0) THEN
		:ligneApres.payee := 1;
	END IF;
END;
/



-----
-- 5d
-----
CREATE OR REPLACE TRIGGER ReduireQuantiteCommande
AFTER INSERT ON LigneLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	LigneCommande
	SET 	qteRestante = (qteRestante - :ligneApres.qteLivraison)
	WHERE 	noProduit = :ligneApres.noProduit AND
		noCommande = :ligneApres.noCommande;
END;
/



------------------------------
-- FONCTIONS
------------------------------
-- 1 Prend un numero article et un numero commande et retourne la quantite deja livree
--
CREATE OR REPLACE FUNCTION QuantiteDejaLivree
(leProduit LigneCommande.noProduit%TYPE, laCommande LigneCommande.noCommande%TYPE)
RETURN LigneCommande.quantite%TYPE IS

	-- Déclaration des variables
	laQuantite	LigneCommande.quantite%TYPE;
	laQteRestante	LigneCommande.qteRestante%TYPE;
	uneQteLivree	LigneCommande.quantite%TYPE;

BEGIN
	SELECT	quantite, qteRestante
	INTO	laQuantite, laQteRestante
	FROM	LigneCommande
	WHERE	LigneCommande.noProduit = leProduit	AND
		LigneCommande.noCommande = laCommande;

	uneQteLivree := laQuantite - laQteRestante;
	
	RETURN uneQteLivree;
END QuantiteDejaLivree;
/



----
-- 2
----
CREATE OR REPLACE PROCEDURE TotalFacture
(leNoLivraison	FactureLivraison.noLivraison%TYPE) IS

	-- Déclaration des variables
	unSousTotal	FactureLivraison.sousTotal%TYPE;	
	unTotal		FactureLivraison.sousTotal%TYPE;	
	
BEGIN
	SELECT	sousTotal
	INTO	unSousTotal
	FROM	FactureLivraison
	WHERE	FactureLivraison.noLivraison = leNoLivraison;

	unTotal := unSousTotal * 1.15;

	DBMS_OUTPUT.PUT('Le total de la facture no. '||leNoLivraison);
	DBMS_OUTPUT.PUT(' est: '||unTotal);
	DBMS_OUTPUT.PUT_LINE('$');
END TotalFacture;
/



----
-- 3
----
CREATE OR REPLACE PROCEDURE ProduireFacture
(leNoLivraison	FactureLivraison.noLivraison%TYPE, laDateLimitePaiement FactureLivraison.dateLimitePaiement%TYPE) IS

	-- Déclaration des variable
	unSousTotal	FactureLivraison.sousTotal%TYPE;
	unTotal		FactureLivraison.sousTotal%TYPE;
	laDateLivraison	FactureLivraison.dateLivraison%TYPE;
	unPrixVente	LigneCommande.prixVente%TYPE;
	unTotalProduit  LigneCommande.prixVente%TYPE;
	unMontantTaxes	FactureLivraison.sousTotal%TYPE;
	leNoClient	Client.noClient%TYPE;
	lePrenom	Client.prenom%TYPE;
	leNom		Client.nom%TYPE;
	leNumeroCivique	Adresse.numeroCivique%TYPE;
	laRue		Adresse.rue%TYPE;
	laVille		Adresse.ville%TYPE;
	lePays		Adresse.pays%TYPE;
	leCodePostal	Adresse.codePostal%TYPE;
	leNoCommande	LigneCommande.noCommande%TYPE;
	laQteLivraison	LigneLivraison.qteLivraison%TYPE;
	leNoProduit	LigneLivraison.noProduit%TYPE;
	leCodeZebre	ItemLivraison.codeZebre%TYPE;

	
	-- Déclaration des curseurs
	CURSOR lignesLivraison (leNoLivraison FactureLivraison.noLivraison%TYPE) IS
		SELECT	noProduit, noCommande, qteLivraison
		FROM	LigneLivraison
		WHERE	LigneLivraison.noLivraison = leNoLivraison;

	CURSOR lignesItemLivraison (leNoLivraison FactureLivraison.noLivraison%TYPE) IS
		SELECT	codeZebre, noProduit, noCommande
		FROM	ItemLivraison
		WHERE	ItemLivraison.noLivraison = leNoLivraison;

BEGIN
	SELECT	MAX(noCommande)
	INTO	leNoCommande
	FROM	LigneLivraison
	WHERE	LigneLivraison.noLivraison = leNoLivraison;

	SELECT	noClient
	INTO	leNoClient
	FROM	Commande
	WHERE	Commande.noCommande = leNoCommande;

	SELECT	numeroCivique, rue, ville, pays, codePostal
	INTO	leNumeroCivique, laRue, laVille, lePays, leCodePostal
	FROM	Adresse
	WHERE	Adresse.noClient = leNoClient AND
		Adresse.noFournisseur = 0;

	SELECT	prenom, nom
	INTO	lePrenom, leNom
	FROM	Client
	WHERE	Client.noClient = leNoClient;

	SELECT	dateLivraison
	INTO	laDateLivraison
	FROM	FactureLivraison
	WHERE 	FactureLivraison.noLivraison = leNoLivraison;

	DBMS_OUTPUT.PUT_LINE('No. livraison:  '||leNoLivraison);
	DBMS_OUTPUT.PUT_LINE('Date livraison: '||laDateLivraison);
	DBMS_OUTPUT.PUT_LINE('No. client:     '||leNoClient);
	DBMS_OUTPUT.PUT_LINE('-------------------------');
	DBMS_OUTPUT.PUT(lePrenom);
	DBMS_OUTPUT.PUT_LINE(' '||leNom);
	DBMS_OUTPUT.PUT(leNumeroCivique);
	DBMS_OUTPUT.PUT_LINE(' '||laRue);
	DBMS_OUTPUT.PUT(laVille);
	DBMS_OUTPUT.PUT_LINE(', '||lePays);
	DBMS_OUTPUT.PUT_LINE(leCodePostal);
	DBMS_OUTPUT.PUT_LINE('-------------------------');
	DBMS_OUTPUT.PUT_LINE('Pro  Code   Comm  Prix');


	unTotal		:= 0;
	unSousTotal	:= 0;

	OPEN lignesLivraison(leNoLivraison);
	LOOP
		FETCH lignesLivraison INTO leNoProduit, leNoCommande, laQteLivraison;
		EXIT WHEN lignesLivraison%NOTFOUND;

		SELECT	prixVente
		INTO	unPrixVente
		FROM	LigneCommande
		WHERE	LigneCommande.noProduit = leNoProduit	AND
			LigneCommande.noCommande = leNoCommande;

		unTotalProduit := laQteLivraison * unPrixVente; 
		unSousTotal := unSousTotal + unTotalProduit;
	END LOOP;
	CLOSE lignesLivraison;


	OPEN lignesItemLivraison(leNoLivraison);
	LOOP
		FETCH lignesItemLivraison INTO leCodeZebre, leNoProduit, leNoCommande;
		EXIT WHEN lignesItemLivraison%NOTFOUND;

		SELECT	prixVente
		INTO	unPrixVente
		FROM	LigneCommande
		WHERE	LigneCommande.noProduit = leNoProduit	AND
			LigneCommande.noCommande = leNoCommande;

		DBMS_OUTPUT.PUT(leNoProduit);
		DBMS_OUTPUT.PUT('    '||leCodeZebre);
		DBMS_OUTPUT.PUT('    '||leNoCommande);
		DBMS_OUTPUT.PUT_LINE('   '||unPrixVente);
	END LOOP;
	CLOSE lignesItemLivraison;


	unMontantTaxes := unSousTotal * 0.15;
	unTotal := unMontantTaxes + unSousTotal;

	UPDATE	FactureLivraison
	SET	sousTotal = unSousTotal, soldeRestant = unTotal
	WHERE	noLivraison = leNoLivraison;

	DBMS_OUTPUT.PUT_LINE('-------------------------');
	DBMS_OUTPUT.PUT_LINE('Sous-total:       '||unSousTotal);
	DBMS_OUTPUT.PUT_LINE('Taxes:             '||unMontantTaxes);
	DBMS_OUTPUT.PUT_LINE('Total:            '||unTotal);

END ProduireFacture;
/
