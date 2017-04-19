SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfConsxNivelUsu1]
@NomUsu nvarchar(20),
@msj varchar(100) output
as

declare @nivel nvarchar(100)
declare @cd_prf nvarchar(6)
select @nivel = Nivel, @cd_prf = Cd_Prf
from Usuario
where NomUsu = @NomUsu
	

select *,(select COUNT(*) from Usuario where Cd_Prf=((select distinct AccesoE.Cd_Prf from AccesoE 
inner join Perfil  on Perfil.Cd_Prf=AccesoE.Cd_Prf
where Perfil.Cd_Prf=@cd_prf))) as 'NumUsu' from Perfil 
where  NivUsuCrea = @nivel or NivUsuCrea like @nivel + '%' or Cd_Prf = @cd_prf





print @msj

--MP : 06/06/2011 : <Creacion del procedimiento almacenado>

/*
exec [dbo].[Seg_PrfConsxNivelUsu] 'admin.nefu', null
select * from Usuario where NomUsu = 'admin.nefu'
select * from Perfil

select * from Perfil 
where NivUsuCrea like 0101116 + '%' or Cd_Prf = @cd_prf

*/
GO
