SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--set @RucE = '20512635025'
CREATE procedure [dbo].[Rpt_PermisosXEmpresa]
@RucE nvarchar(11)
as
Select case when len(Cd_MN)=2 then Nombre else 
				case when len(Cd_MN)=4 then '    '+Nombre else 
				case when len(Cd_MN)=6 then '         '+Nombre else
				case when len(Cd_MN)=8 then '               '+Nombre  else
				case when len(Cd_MN)=10 then '                  '+Nombre 
				end end end end end as Menu
				,Cd_MN From Menu Where Estado=1


Select   distinct   us.NomUsu,ae.Cd_Prf,us.Estado
From  Usuario us
            Inner Join AccesoE ae On ae.Cd_Prf=us.Cd_Prf 
Where ae.RucE=@RucE /*and us.Estado=1*/ and us.Cd_Prf<>'001'
Order by 2


Select   distinct   ae.Cd_Prf,/*am.Cd_GA,*/me.Cd_MN,me.Nombre
From  Menu me
            Inner Join AccesoM am On am.Cd_MN=me.Cd_MN
            Inner Join AccesoE ae On ae.Cd_GA=am.Cd_GA
Where ae.RucE=@RucE and ae.Cd_Prf<>'001'
Order by 1,2


--Lista todos los perfiles y sus permisos en el sistema
--Creado JA: <16/09/2011>
--exec Rpt_PermisosXEmpresa '20451804848'

--select * from empresa where Rsocial like '%Conca%'
GO
