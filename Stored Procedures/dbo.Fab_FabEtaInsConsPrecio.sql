SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_FabEtaInsConsPrecio]

@RucE nvarchar(11),
@Cd_Prod varchar(500),
@ID_UMP varchar(500),
@Fec datetime,
@msj varchar(100) output
as

declare @CadenaCd_Prod varchar(4000) = @Cd_Prod
declare @lstCadena varchar(700) = @ID_UMP
declare @lstDato varchar(7)
declare @lnuPosComa int
DECLARE @TablaCosto TABLE (Cd_Prod varchar(7), ID_UMP int, Costo decimal(13,7),Costo_ME decimal(13,7))
while(len(@CadenaCd_Prod) >0)  
begin
	SET @lnuPosComa = CHARINDEX(',', @lstCadena ) -- Buscamos el caracter separador
    IF ( @lnuPosComa=0 )
    BEGIN
        SET @lstDato = @lstCadena
        SET @lstCadena = ''
    END
    ELSE
    BEGIN
        SET @lstDato = Substring( @lstCadena , 1  , @lnuPosComa-1)
        SET @lstCadena = Substring( @lstCadena , @lnuPosComa + 1 , LEN(@lstCadena))
    END
	 INSERT INTO @TablaCosto  select Convert(char(7), @CadenaCd_Prod) as CodProd,ltrim(rtrim(@lstDato )) as ID_UMP, 
		dbo.CostSal3(@RucE ,@CadenaCd_Prod , ltrim(rtrim(@lstDato )) , @Fec , '01') as Costo,
		dbo.CostSal3(@RucE ,@CadenaCd_Prod , ltrim(rtrim(@lstDato )) , @Fec , '02') as Costo_ME
	set @CadenaCd_Prod = right(@CadenaCd_Prod, len(@CadenaCd_Prod)-7)
	--select dbo.CostSal3(@RucE ,@CadenaCd_Prod , ltrim(rtrim(@lstDato )) , getdate() , '01') as Costo,
	--	   dbo.CostSal3(@RucE ,@CadenaCd_Prod , ltrim(rtrim(@lstDato )) , getdate() , '02') as Costo_ME
end
	SELECT * FROM @TablaCosto
print @msj

-- exec Fab_FabEtaInsConsPrecio '11111111111','PD00001PD00002PD00004PD00019PD00048PD00164PD00232PD00232','12,9,24,1,2,1,1,1','20130105',null

GO
