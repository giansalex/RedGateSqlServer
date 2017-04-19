SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Vta_CampoVCons_Mdf]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
begin
select a.Cd_Cp as CodCampo, a.Nombre as NomCampo, b.Valor as ValorCampo from Campo a
left join CampoV b on a.RucE=b.RucE and a.Cd_Cp=b.Cd_Cp and Cd_Vta=@Cd_Vta
where a.RucE=@RucE

--	select v.Cd_Cp as CodCampo,c.Nombre as NomCampo,v.Valor as ValorCampo 
--	from  Campo c
--	left join CampoV v on c.RucE=v.RucE and c.Cd_Cp=v.Cd_Cp and v.Cd_Vta=@Cd_Vta
--	where v.RucE=@RucE 
	--and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp
end
print @msj
GO
