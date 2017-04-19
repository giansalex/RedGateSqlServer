SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamCrea3]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@TCCom numeric(13,3),
@TCVta numeric(13,3),
@TCPro numeric(13,3),
@UsuCrea nvarchar(10),
@msj varchar(100) output
as

Declare @Est nvarchar(2)

--if(lower(@UsuCrea--in('admin','willy','fiore','jvalle','j.gonzales','z.boris','rafael','gersi','pierre','edgar','ivan','gacosta','emer1','jguillen','diego','jesus','mrosario','mila','b.marin' ,'jcortez','shirley','krodriguez','t.susana','mtubillas','vilma','josel','juanqv','mprado','alvaro.mir','flucar','f.rafael','INGETROL','V.EDUARDO','jvega','G.MARIA', 'enriqueta.','T.MIGUEL','L.ADMINIST','L.ASISTENT', 'O.ARETI','dayanna', 'ptellez','g.marlene','r.melissa','C.FERNANDO','C.MARITZA', 'g.fiorella', 'JORGE-1','S.MELIZA', 'coqueliz','lucia','americo','julio.koch','l.saul','sonia.pauc','miguel.bar','r.juan','c.noemi','l.antonio','l.jorge','a.mirtha','g.jose','rurbano','lpillaca','ptellez', 'demale1','p.susy','kajara','oscar.meji'))
--if(lower(@UsuCrea)='admin' or lower(@UsuCrea)='willy' or lower(@UsuCrea)='fiore' or lower(@UsuCrea)='jvalle' or lower(@UsuCrea)='j.gonzales' or lower(@UsuCrea)='boris' or lower(@UsuCrea)='rafael' or lower(@UsuCrea)='gersi' or lower(@UsuCrea)='pierre' or lower(@UsuCrea)='edgar' or lower(@UsuCrea)='ivan' or lower(@UsuCrea)='gacosta' or lower(@UsuCrea)='emer1' or lower(@UsuCrea)='jguillen' or lower(@UsuCrea)='diego' or lower(@UsuCrea)='jesus' or lower(@UsuCrea)='mrosario')--USU TIENE PERMISOS
if exists (select * from usuario where NomUsu = @UsuCrea and isnull(IB_TipCamCrear,0)=1 and Estado=1)
begin
	set @Est='01'
	if exists (select * from TipCam where FecTC=@FecTC and Cd_Mda=@Cd_Mda)
	begin
	   set @msj = 'Fecha Tipo de Cambio ya existe'
    end
	else
	begin
	    insert into TipCam(FecTC,Cd_Mda,TCCom,TCVta,TCPro,UsuCrea)
		        values (@FecTC,@Cd_mda,@TCCom,@TCVta,@TCPro,@UsuCrea)
	
	   if @@rowcount<=0
	   set @msj = 'Tipo de Cambio no pudo ser ingresado'
	
	end
end
else
begin	
	set @Est='05'
	set @msj = 'No tiene permisos para registrar Tipo de Cambio'
end
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from TipCamRM)
	insert into TipCamRM(NroReg,FecTC,Cd_Mda,TCCom,TCVta,TCPro,Usu,FecMov,Cd_Est)
		values(@NroReg,@FecTC,@Cd_Mda,@TCCom,@TCVta,@TCPro,@UsuCrea,getdate(),@Est)

print @msj


--MP : 15/02/2011 : <Modificacion del procedimiento almacenado>
--MP : 14/04/2011 : <Modificacion del procedimiento almacenado>

--select * from Usuario where NomComp like '%sonia%'
GO
