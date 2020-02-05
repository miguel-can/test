
--*************************************************
-- Proporcionar el valor de las variables

-- Se buscan los servicios con fecha de ALTA Menor o Igual a la fecha indicada en está variable
DECLARE @dtFecha VARCHAR(30) = '26/09/2019' 

-- Dividir por comás los tramites de MEJORA ejemplo, A03,A001, ETC
DECLARE @cTramites	VARCHAR(MAX) = 'A03'	

-- 0: Aplica cambios Permanente
-- 1: Solo hace una consulta para presentarte los Servicios que va a actualizar 
DECLARE @lConsulta BIT = 1

--*************************************************


DECLARE @iTiFirElectronica INT = 0
DECLARE @tblTramites TABLE (iIdTramite INT)
DECLARE @tblServicio TABLE (iFolioServicio INT, cResponsable VARCHAR(MAX), cClave VARCHAR(10), cTramite VARCHAR(MAX),  iFolioCedula INT)

-- Se obtiene el identificador del tipo de firma ELECTRÓNICA
SELECT @iTiFirElectronica = iIdTipoFirma 
FROM CATASTRO.CfgServicio.Cat_TipoFirma 
WHERE lActivo = 1 and lFirmaElectronica = 1

INSERT INTO @tblTramites
SELECT iIdTramite FROM CATASTRO.CfgServicio.Cat_Tramite TRA (NOLOCK)
WHERE cClave in
(
	select item from CATASTRO.[dbo].[udf_SplitString](@cTramites,',')
)

INSERT INTO @tblServicio
SELECT SER.iFolioServicio, FIR.cNombre,TRA.cClave, TRA.cNombre, RES.iFolioCedula
FROM CATASTRO.SolServicio.Servicios SER (NOLOCK)
INNER JOIN @tblTramites TMP
	ON SER.iIdTramite = TMP.iIdTramite
INNER jOIN CATASTRO.CfgServicio.Cat_Tramite TRA (NOLOCK)
	ON SER.iIdTramite = TRA.iIdTramite
INNER JOIN Catastro.Catastro.tbl_Rel_ServicioCedulaResultado RES (NOLOCK)
	ON SER.iIdServicio = RES.iIdServicio	
INNER JOIN CATASTRO.catastro.FirmaCedula FIR (NOLOCK)
	ON RES.iFolioCedula = FIR.iFolioCedula
WHERE 
CONVERT(date,SER.dtAlta,103) <= CONVERT(date,@dtFecha,103)
AND IESTATUS IN
(
	2,3 
)
AND FIR.lFirmaEjecutada = 0
AND FIR.iIdTipoFirma <> @iTiFirElectronica
--AND SER.iFolioServicio = 1736477
ORDER BY SER.dtAlta desc


IF(@lConsulta = 1)
BEGIN

SELECT 'SE ACTUALIZARIAN LOS SIGUIENTES SERVICIOS:'
SELECT * from @tblServicio

END
ELSE
BEGIN

UPDATE CATASTRO.Catastro.FirmaCedula 
SET lFirmaEjecutada = 1
WHERE iFolioCedula in
(
	SELECT iFolioCedula from @tblServicio
)


SELECT 'SE ACTUALIZARON PERMANENTEMENTE LOS SIGUIENTES SERVICIOS:'
SELECT * from @tblServicio

END






