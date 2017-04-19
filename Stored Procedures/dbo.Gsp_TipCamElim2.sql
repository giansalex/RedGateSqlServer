SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamElim2]
@FecTC varchar(10),
@UsuMdf varchar(10),
@msj varchar(100) output
as
	Declare @Est nvarchar(2)
	Declare @Cd_Mda nvarchar(2)
	Declare @TCCom decimal(13,3)
	Declare @TCVta decimal(13,3)
	Declare @TCPro decimal(13,3)
	--Declare @UsuMdf varchar(10)	
	select @Cd_Mda=Cd_Mda,@TCCom=TCCom,@TCVta=TCVta,@TCPro=TCPro from TipCam where FecTC=@FecTC 		
	--update usuario set IB_TipCamElim=1 where NomUsu in('admin','willy','fiore','jvalle','j.gonzales','z.boris','rafael','gersi','pierre','edgar','ivan','gacosta','emer1','jguillen','diego','jesus','mrosario','mila','b.marin','krodriguez','shirley','t.susana','juanqv','alvaro.mir','f.rafael','INGETROL','T.MIGUEL','L.ADMINIST','L.ASISTENT', 'O.ARETI','ptellez','g.marlene','URSULA', 'g.fiorella', 'mprado', 'C.MARITZA', 'coqueliz','lucia','americo','julio.koch','l.saul','sonia.pauc','miguel.bar','r.juan','c.noemi','l.antonio','l.jorge','a.mirtha','g.jose','rurbano','lpillaca','ptellez','p.susy','kajara','oscar.meji')
--if(lower(@UsuMdf) in('admin','willy','fiore','jvalle','j.gonzales','z.boris','rafael','gersi','pierre','edgar','ivan','gacosta','emer1','jguillen','diego','jesus','mrosario','mila','b.marin','krodriguez','shirley','t.susana','juanqv','alvaro.mir','f.rafael','INGETROL','T.MIGUEL','L.ADMINIST','L.ASISTENT', 'O.ARETI','ptellez','g.marlene','URSULA', 'g.fiorella', 'mprado', 'C.MARITZA', 'coqueliz','lucia','americo','julio.koch','l.saul','sonia.pauc','miguel.bar','r.juan','c.noemi','l.antonio','l.jorge','a.mirtha','g.jose','rurbano','lpillaca','ptellez','p.susy','kajara','oscar.meji'))	--Usuarios con permisos poner en MINUSCULA para seguir un ESTANDAR
--if(lower(@UsuMdf)='admin' or lower(@UsuMdf)='willy' or lower(@UsuMdf)='fiore' or lower(@UsuMdf)='jvalle' or lower(@UsuMdf)='j.gonzales' or lower(@UsuMdf)='boris' or lower(@UsuMdf)='rafael' or lower(@UsuMdf)='gersi' or lower(@UsuMdf)='pierre' or lower(@UsuMdf)='edgar' or lower(@UsuMdf)='ivan' or lower(@UsuMdf)='gacosta' or lower(@UsuMdf)='emer1' or lower(@UsuMdf)='jguillen' or lower(@UsuMdf)='diego' or lower(@UsuMdf)='jesus' or lower(@UsuMdf)='mrosario')--USU TIENE PERMISOS
if exists (select * from usuario where NomUsu = @UsuMdf and isnull(IB_TipCamElim,0)=1 and Estado=1)
begin
	if not exists (select * from TipCam where FecTC=@FecTC)
		set @msj = 'Fecha Tipo de Cambio no existe'
		else
	begin	
		set @Est='03'			
------------------------------------------------------------------------------------------
		delete TipCam Where FecTC = @FecTC
		if @@rowcount <= 0
		set @msj = 'Tipo de Cambio no pudo ser eliminado'
	end
end
else
begin	
	set @Est='07'
	set @msj = 'No tiene permisos para eliminar Tipo de Cambio'
end
------------------------------------------------------------------------------------------
--INSERTANDO MOVIMIENTO DE REGISTRO
------------------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from TipCamRM)
	insert into TipCamRM(NroReg,FecTC,Cd_Mda,TCCom,TCVta,TCPro,Usu,FecMov,Cd_Est)
	       Values(@NroReg,@FecTC,@Cd_Mda,@TCCom,@TCVta,@TCPro,@UsuMdf,getdate(),@Est)
------------------------------------------------------------------------------------------
print @msj

GO
