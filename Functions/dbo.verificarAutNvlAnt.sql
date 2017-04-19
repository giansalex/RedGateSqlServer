SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[verificarAutNvlAnt](
	@RucE nvarchar(11), 	
	@Cd_Doc char(10), 	
	@Id_NivAnt int, 	
	@IB_AutComNivAnt bit,
	@TipoDoc int )
RETURNS bit AS  
BEGIN 

	declare @num1 int
	declare @num2 int
	declare @valorRetorno bit

	set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @Id_NivAnt)
/*
	set @Cadena = 'select @cont = count(*) from '+@Tabla+' a join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc +''' and b.Id_Niv = '''+@id+''''

	exec sp_executesql @Cadena, N'@cont int out', @num2 out
*/

	if(@TipoDoc = 0)
			set @num2 = (select count (*) from AutOC a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_OC = @Cd_Doc and b.Id_Niv = @Id_NivAnt)	
	else if(@TipoDoc = 1)
			set @num2 = (select count (*) from AutOP a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_OP = @Cd_Doc and b.Id_Niv = @Id_NivAnt)
	else if(@TipoDoc = 2)
			set @num2 = (select count (*) from AutSC a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_Sco = @Cd_Doc and b.Id_Niv = @Id_NivAnt)
	else if(@TipoDoc = 3)
			set @num2 = (select count (*) from AutSR a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_SR = @Cd_Doc and b.Id_Niv = @Id_NivAnt)
	else if(@TipoDoc = 4)
			set @num2 = (select count (*) from AutOF a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_OF = @Cd_Doc and b.Id_Niv = @Id_NivAnt)
	else if(@TipoDoc = 5)
			set @num2 = (select count (*) from AutCot a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
			where a.RucE = @RucE and a.Cd_Cot = @Cd_Doc and b.Id_Niv = @Id_NivAnt)


	if(@IB_AutComNivAnt = 1)--nivel completo
	begin
		if(@num1 = @num2) set @valorRetorno = 1
		else set @valorRetorno = 0
	end
	else
	begin
		if(@num2>0) set @valorRetorno = 1
		else set @valorRetorno = 0
	end
	return @valorRetorno
END



GO
