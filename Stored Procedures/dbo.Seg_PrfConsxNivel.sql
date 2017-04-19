SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfConsxNivel]
@NomUsu nvarchar(20),
@msj varchar(100) output
as

declare @nivel varchar(100)
select @nivel = Nivel from Usuario
where NomUsu = @NomUsu

select * from Perfil where Cd_Prf in 
(select distinct usu.Cd_Prf from Usuario usu
inner join Perfil prf on usu.Cd_Prf = prf.Cd_Prf
where usu.Nivel like '' + @nivel + '%')

print @msj

--MP : 30/05/2011 : <Creacion del procedimiento almacenado>

exec [dbo].[Seg_PrfConsxNivel] 'mprado', null
GO
