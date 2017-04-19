SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamMdf2]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@TCCom numeric(13,3),
@TCVta numeric(13,3),
@TCPro numeric(13,3),
@UsuCrea nvarchar(10),
@msj varchar(100) output
as
Declare @Est nvarchar(2)
if exists (select * from usuario where NomUsu = @UsuCrea and isnull(IB_TipCamMdf,0)=1 and Estado=1)
begin
	set @Est='02'
	if not exists (select * from TipCam where FecTC=@FecTC)
  		set @msj = 'Fecha Tipo de Cambio no existe'
	else
	begin
		update TipCam set Cd_Mda=@Cd_Mda, TCCom=@TCCom, TCVta=@TCVta, TCPro=@TCPro,UsuCrea=@UsuCrea
		where FecTC=@FecTC and Cd_Mda=@Cd_Mda
	
		if @@rowcount <= 0
      		set @msj = 'Tipo de Cambio no pudo ser modificado'
	end
end
else
begin	
	set @Est='06'
	set @msj = 'No tiene permisos para modificar Tipo de Cambio'
end
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from TipCamRM)
	insert into TipCamRM(NroReg,FecTC,Cd_Mda,TCCom,TCVta,TCPro,Usu,FecMov,Cd_Est)
		values(@NroReg,@FecTC,@Cd_Mda,@TCCom,@TCVta,@TCPro,@UsuCrea,getdate(),@Est)

print @msj
/*
select * from TipCam where FecTC='02/07/2012'
select * from usuario where NomUsu = 'coqueliz' and isnull(IB_TipCamMdf,0)=1 and Estado=1

exec Gsp_TipCamMdf2 '02/07/2012','02',2.66,2.662,2.661,'coqueliz',''

select * from TipCamRM

update TipCam set Cd_Mda='02', TCCom=2.66, TCVta=2.662, TCPro=2.661,UsuCrea='coqueliz'
		where FecTC='02/07/2012' and Cd_Mda = '02'
		
		select top 3 * from TipCam where FecTC = '02/07/2012' and Cd_Mda='02' 
		*/
GO
