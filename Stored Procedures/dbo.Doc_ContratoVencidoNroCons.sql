SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Doc_ContratoVencidoNroCons]
@RucE char(11),
@NomUsu nvarchar(20),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	if not exists (select * from areaxusuario where RucE=@RucE and NomUsu=@NomUsu)
		set @msj = 'Usuario no existe'
	else
		begin
			select count(RucE) as 'Nro'
			from contrato
			where RucE=@RucE and datediff(d,getdate(),fecfin)<0 and datediff(d,getdate(),fecfin)>-31
		end
END
GO
