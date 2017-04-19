SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Doc_ContratoPendienteNroCons1]
@RucE char(11),
@NomUsu nvarchar(20),
@Dias varchar(100),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	if isnull(@Dias,'')=''
	 set @Dias = '8'

	if not exists (select * from areaxusuario where RucE=@RucE and NomUsu=@NomUsu)
		set @msj = 'Usuario no existe'
	else
		begin
			select count(RucE) as 'Nro'
			from contrato
			where RucE=@RucE and datediff(d,getdate(),fecfin)<convert(int,@Dias) and datediff(d,getdate(),fecfin)>-1
		end
END
GO
