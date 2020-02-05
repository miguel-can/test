/*********************************************************************************************************
* BLUE OCEAN TECHNOLOGIES S.A. DE C.V.                                                                     
* Generado por:         Jean Carlo Loza Carbajal
* Fecha de Generación:  19/12/2019
* Hora de Generación:   12:00 p.m.
* ID del Requerimiento: 216062 - Cobro automático de servicios por secciones
*********************************************************************************************************/

SET XACT_ABORT ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION

/*********************************************************************************************************
* BLUE OCEAN TECHNOLOGIES S.A. DE C.V.                                                                     
* Sistema:             Sistema Integral de Catastro                                                       
* Módulo:              Administrador de Catalogos
* Generado por:        Jean Carlo Loza Carbajal
* Fecha de Generación: 19/12/2019
* Hora de Generación:  12:05 p.m.
* Objetivo del Script: Crear la columna lCobroSeccion en la tabla de CfgServicio.tblCat_Derechos
* Descripción:         Se agrega la columna que indicara si se va a calcular la cantidad de UMAS dependiendo de la seccion del predio
* ID Componente		   218789 - Crear scripts
*********************************************************************************************************/
/*INICIO*/
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM sys.databases WHERE name = 'CATASTRO')
		BEGIN  
			USE CATASTRO
			--Se crea la columna para el identificador del municipio
			EXEC [dbo].[uspAgregarColumna] N'CfgServicio', N'tblCat_Derechos', N'lCobroSeccion', 'BIT NOT NULL DEFAULT 0', N'Columna que indica si se calcula el cobro por seccion';
		END
	END
/*FIN*/
/*********************************************************************************************************
* BLUE OCEAN TECHNOLOGIES S.A. DE C.V.                                                                     
* Sistema:             Sistema Integral de Catastro                                                       
* Módulo:              Administrador de Catalogos
* Generado por:        Jean Carlo Loza Carbajal
* Fecha de Generación: 19/12/2019
* Hora de Generación:  12:06 p.m.
* Objetivo del Script: Crear la tabla CfgServicio.tblRel_DerechoSeccion
* Descripción:         Esa tabla se usara para guardar la relacion de las secciones configuradas al derecho y el factor de cada una de estas
* ID Componente		   218789 - Crear scripts
*********************************************************************************************************/
/*INICIO*/
	BEGIN 
		IF EXISTS (SELECT TOP 1 1 FROM sys.databases WHERE name = 'CATASTRO')
		BEGIN  
	
			USE CATASTRO
	
			DECLARE @cEsquema  VARCHAR(100)= 'CfgServicio';
			DECLARE @cTabla VARCHAR(100) = 'tblRel_DerechoSeccion';
	
			IF NOT EXISTS (SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @cEsquema and TABLE_NAME = @cTabla)
			BEGIN
		
				CREATE TABLE CfgServicio.tblRel_DerechoSeccion(
					iIdSeccionDerecho INT IDENTITY(1,1) NOT NULL PRIMARY KEY,		  
					iIdSeccion INT NOT NULL,
					iIdDerecho INT NOT NULL,
					dFactor DECIMAL(18,2) NOT NULL
					) 
			
				EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único de la tabla' , @level0type=N'SCHEMA',@level0name=N'CfgServicio', 
					@level1type=N'TABLE',@level1name=N'tblRel_DerechoSeccion', @level2type=N'COLUMN',@level2name=N'iIdSeccionDerecho'
								
				EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'identificador de la tabla [CATASTRO].[Catastro].[Cat_Region] con la que se relaciona', 
					@level0type=N'SCHEMA',@level0name=N'CfgServicio', @level1type=N'TABLE',@level1name=N'tblRel_DerechoSeccion', 
					@level2type=N'COLUMN',@level2name=N'iIdSeccion'
								
				EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'identificador de la tabla [CATASTRO].[CfgServicio].[tblCat_Derechos] con la que se relaciona' , @level0type=N'SCHEMA',@level0name=N'CfgServicio', 
					@level1type=N'TABLE',@level1name=N'tblRel_DerechoSeccion', @level2type=N'COLUMN',@level2name=N'iIdDerecho'
								
				EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'El factor configurado para esta sección en este derecho' , @level0type=N'SCHEMA',@level0name=N'CfgServicio', 
					@level1type=N'TABLE',@level1name=N'tblRel_DerechoSeccion', @level2type=N'COLUMN',@level2name=N'dFactor'
							
				PRINT 'Se ha creado la tabla ' + @cEsquema + '.' + @cTabla
			END
			ELSE
			BEGIN
				PRINT 'La tabla ' + @cEsquema + '.' + @cTabla + ' ya existe!'
			END
		END
		ELSE
		BEGIN
			PRINT '¡NO SE CREO LA TABLA, NO FUE ENCONTRADO LA BASE DE DATOS DE CATASTRO!'
		END
	END 
/*FIN*/
COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @Error_Number INT,
        @Error_Severity INT ,
        @Error_State INT,
        @Error_Procedure VARCHAR(1000) ,
        @Error_Line INT,
        @Error_Message VARCHAR(8000);
		
	SELECT @Error_Number = ERROR_NUMBER(),
		@Error_Severity = ERROR_SEVERITY(),
		@Error_State = ERROR_STATE(),
		@Error_Procedure = ERROR_PROCEDURE(),
		@Error_Line = ERROR_LINE(),
		@Error_Message = ERROR_MESSAGE();

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		
	RAISERROR(@Error_Message, @Error_Severity, @Error_State);
    PRINT 'Ocurrió el siguiente error en la ejecucion del script: ' + CONVERT(VARCHAR(MAX), @Error_Message) + CONVERT(VARCHAR(MAX), @Error_Severity) + CONVERT(VARCHAR(MAX), @Error_State)

END CATCH
GO