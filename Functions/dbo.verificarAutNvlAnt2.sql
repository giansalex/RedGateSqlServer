SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[verificarAutNvlAnt2](@RucE nvarchar(11), @Cd_Doc char(10), @niv int, @IB_AutComNiv bit, @TipoDoc int )
RETURNS BIT AS  
BEGIN
	declare @nivel int, @idNiv int, @num1 int, @num2 int
	
	if(@niv = 1)	set @nivel = 1;
	else set @nivel = @niv - 1; 
	
		
	if(@TipoDoc = 0)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'OC' 
		and tipo = (select tipAut from ordCompra where RucE = @RucE and cd_OC = @Cd_Doc)) 
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutOC a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_OC = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	if(@TipoDoc = 1)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'OP' 
		and tipo = (select tipAut from ordPedido where RucE = @RucE and cd_OP = @Cd_Doc)) 
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutOP a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_OP = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	if(@TipoDoc = 2)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'SC' 
		and tipo = (select tipAut from solicitudCom where RucE = @RucE and Cd_SC = @Cd_Doc)) 
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutSC a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_SCo = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	if(@TipoDoc = 3)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'SR' 
		and tipo = (select tipAut from solicitudReq where RucE = @RucE and Cd_SR = @Cd_Doc)) 
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutSR a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_SR = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	if(@TipoDoc = 4)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'OF' 
		and tipo = (select tipAut from ordFabricacion where RucE = @RucE and cd_OF = @Cd_Doc))
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutOF a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_OF = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	if(@TipoDoc = 5)
	begin
		set @idNiv = ( select id_niv from cfgnivelaut 
		where id_aut = (select id_aut from cfgautorizacion where RucE = @RucE and Cd_DMA = 'CT' 
		and tipo = (select tipAut from cotizacion where RucE = @RucE and cd_Cot = @Cd_Doc))
		and niv = @nivel)
		
		set @num1 = (select count (*) from CfgAutsXUsuario where Id_Niv = @idNiv)
		set @num2 = (select count (*) from AutCot a inner join CfgAutsXUsuario b on a.NomUsu = b.NomUsu 
				where a.RucE = @RucE and a.Cd_Cot = @Cd_Doc and b.Id_Niv = @idNiv)
	end
	------------------------------------------------------------------------------------------------------------
	declare @valorRetorno bit
	if(@IB_AutComNiv = 1)
	begin
		if(@num1 = @num2) set @valorRetorno = 1
		else set @valorRetorno = 0
	end
	else
	begin
		if(@num2>0) set @valorRetorno = 1
		else set @valorRetorno =  0
	end
	return @valorRetorno
END
GO
