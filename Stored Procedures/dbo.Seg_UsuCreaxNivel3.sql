SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuCreaxNivel3]
@NomUsu	nvarchar(10),
@NomUsuCrea	nvarchar(10),
@Pass	nvarchar(50),
@NomComp varchar(50),
@Cd_Trab nvarchar(15),
@Cd_Prf	nvarchar(3),
@IB_TipCamCrear bit,
@IB_TipCamMdf bit,
@IB_TipCamElim bit,
@correo1 nvarchar(100),
@UsuCrea nvarchar(10),
@FecReg datetime,
@Cargo nvarchar(200),

--@Estado	bit
@msj varchar(100) output
as
if exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario ya existe.'
else
begin
    insert into Usuario(NomUsu,Pass,NomComp,Cd_Trab,Cd_Prf,Nivel,Estado,IB_TipCamCrear,IB_TipCamMdf,IB_TipCamElim,Correo1,UsuCrea,FecReg,Cargo)
	        values (@NomUsu,@Pass,@NomComp,@Cd_Trab,@Cd_Prf,
			dbo.Asigna_NivelxUsuario(@NomUsuCrea),1,@IB_TipCamCrear,@IB_TipCamMdf,@IB_TipCamElim,@correo1,@UsuCrea, @FecReg,@Cargo)
    if @@rowcount<=0
       set @msj = 'Usuario no pudo ser creado.'
end
print @msj
--select * from Usuario
--print dbo.Asigna_NivelxUsuario('A.CARLOS')

--MP : 2011/06/01 : <Modificacion del procedimiento almacenado>
--print dbo.Asigna_NivelxUsuario('admin.nefu')
--select * from Usuario where NomUsu = 'admin.nefu'
GO
