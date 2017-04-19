SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaCrea]
--@ItmA nvarchar(5),
@RucE nvarchar(11),
@NroCta nvarchar(10),
@CtaD nvarchar(10),
@CtaH nvarchar(10),
@Porc numeric(6,2),
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists (select * from Empresa where Ruc=@RucE)
	set @msj = 'Empresa no existe'
else if not exists (select * from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
             set @msj = 'Cuenta no esta asignada a esta empresa'  
else 
begin
	insert into AmarreCta(Item,RucE,NroCta,CtaD,CtaH,Porc,Ejer)
	               values(dbo.Item_AmarreCta(@RucE),@RucE,@NroCta,@CtaD,@CtaH,@Porc,@Ejer)
	if @@rowcount <= 0
	   set @msj = 'Amarre Cuenta no pudo ser registrado'
end
print @msj

----------------------PRUEBA------------------------
--exec Ctb_AmarreCtaCrea '11111111111','14.1.0.06','24.1.0.01','61.4.0.01','100.00','2010',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>
--MP : 23/10/2011 : <Creacion del procedimiento almacenado>

GO
