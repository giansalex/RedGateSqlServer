SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Gfm_TipMantCrea](
	@Cd_TM char(2) output,
	@RucE nvarchar(11),
	@Descrip varchar(100),
	@Es_MntGN bit,
	@Estado bit,
	@msj varchar(100) output
)
AS
IF EXISTS ( SELECT * FROM Tabla WHERE Nombre = @Descrip )
	set @msj = 'Tipo de mantenimiento no pudo ser registrado, ya existe una tabla con ese nombre.'
else
begin
	set @Cd_TM = dbo.Cd_TM(@RucE)
	INSERT INTO TipMant(RucE,Cd_TM,Descrip,Es_MntGN,Estado)
	VALUES(@RucE,@Cd_TM,@Descrip,@Es_MntGN,@Estado)
	if @@rowcount <= 0
		set @msj = 'Tipo de mantenimiento no pudo ser registrado.'
	else
	begin
		declare @CodTabla char(4)
		set @CodTabla = dbo.Cod_Tabla()
		exec [user321].[TablaCrea] @CodTabla, @Descrip, @msj output
		
		declare @nroCampos int
		select @nroCampos = COUNT(*) from CampoTabla
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA01','Dato 1', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA02','Dato 2', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA03','Dato 3', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA04','Dato 4', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA05','Dato 5', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA06','Dato 6', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA07','Dato 7', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA08','Dato 8', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA09','Dato 9', 1, null
		exec [user321].[CampoTablaCrea] @nroCampos,@CodTabla,'CA10','Dato 10', 1, null
		
		insert into TablaxMod values ('10',@CodTabla)
	end
end

--MP: 20/07/2012 <Modificacion del procedimiento almacenado>
GO
