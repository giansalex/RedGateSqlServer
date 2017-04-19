SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2Crea4_Import]
@RucE nvarchar(11),
@Ejer varchar(4),
@CodCo varchar(30),
@Nombre varchar(100),
@Descrip varchar(300),
@NCorto varchar(10),
@Cta1 nvarchar(15),
@Cta2 nvarchar(15),
@Cta3 nvarchar(15),
@Cta4 nvarchar(15),
@Cta5 nvarchar(15),
@Cta6 nvarchar(15),
@Cta7 nvarchar(15),
@Cta8 nvarchar(15),
@Img image,
@Cd_GS varchar(6),
@Cd_CGP char(4),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@UsuCrea varchar(50),
@Ic_TipServ char(1),
--@UsuMdf varchar(50),
--@FecReg datetime,
--@FecMdf datetime,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(300),
@CA10 varchar(300),
@Cd_Srv char(7) output,
@msj varchar(100) output
as


/******* Validacion ****************/



if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@Cta1) and  (Isnull(@Cta1,'')<>'')
begin
	set @msj = ' No existe Cuenta Contable 1 :'+ @Cta1
	return
end

if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@Cta2) and (Isnull(@Cta2,'')<>'')
begin
	set @msj = ' No existe Cuenta Contable 2 :'+@Cta2
	return
end

if not exists(select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)  and  (Isnull(@Cd_GS,'')<>'')
 begin 
	set @msj = 'No existe Codigo Grupo Servico: ' +isnull(@Cd_GS,'Vacio')
	return
 end



set @msj=dbo.Valida_CentrosDeCosto(@RucE,@Cd_CC,@Cd_SC,@Cd_SS)
  
  if(@msj<>'')
    begin
	return 
	end


/**********end Validacion ******************/

if exists (select * from Servicio2 where RucE=@RucE and Ic_TipServ = @Ic_TipServ and  CodCo=@CodCo)
--if exists (select * from Servicio2 where RucE=@RucE and Nombre=@Nombre and Ic_TipServ = @Ic_TipServ )
	print 'Ya existe ese Servicio '
else
begin
--	declare @Cd_Srv char(7)
	if(@Ic_TipServ='V')
		begin
		set @Cd_Srv=User321.Cod_Srv2(@RucE)
		end
	else
		begin
		set @Cd_Srv=User123.Cod_Srv2Com(@RucE)
		end

	insert into Servicio2(RucE,CodCo,Cd_Srv,Nombre,Descrip,NCorto,Cta1,Cta2,Cta3,Cta4,Cta5,Cta6,Cta7,Cta8,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,Usucrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Ic_TipServ)
		    values(@RucE,@CodCo,@Cd_Srv,@Nombre,@Descrip,@NCorto,@Cta1,@Cta2,@Cta3,@Cta4,@Cta5,@Cta6,@Cta7,@Cta8,@Img,@Cd_GS,@Cd_CGP,@Cd_CC,@Cd_SC,@Cd_SS,@UsuCrea,null,getdate(),null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Ic_TipServ)
	
	if @@rowcount <= 0
	   set @msj = 'El Servicio no pudo ser creado'
end
print @msj


-- 24/08/2011 : JV - SE ELIMINA LA VALIDACIÓN NO REPETICION DE NOMBRE PARA ALTA DE SERVICIO.


GO
