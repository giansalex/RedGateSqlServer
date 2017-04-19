SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_VtaDetalleCrea3]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Pro nvarchar(10),
@Cant numeric(13,2),
@Cd_UM nvarchar(2),
@Valor numeric(13,2),
@DsctoP numeric(5,2),
@DsctoI numeric(13,2),
@IMP numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@Ad_INF_Vta numeric(13,2) output,
@Ad_BIM_Vta numeric(13,2) output,
@Ad_IGV_Vta numeric(13,2) output,
@Ad_Total_Vta numeric(13,2) output,
--@IB_Term bit,  --> Para que?

@CA01 varchar(300),
@CA02 varchar(300),
@CA03 varchar(50),
@CA04 varchar(50),
@CA05 varchar(50),
@CA06 varchar(50),
@CA07 varchar(50),
@CA08 varchar(50),
@CA09 varchar(50),
@CA10 varchar(50),

@msj varchar(100) output
as

begin transaction


declare @NroDoc nvarchar(15)--, @Cd_Sr nvarchar(4)
declare @Cd_CC nvarchar(8), @Cd_SC nvarchar(8), @Cd_SS nvarchar(8)
--declare @Cd_CC_Pro nvarchar(8), @Cd_SC_Pro nvarchar(8), @Cd_SS_Pro nvarchar(8)

  --select @NroDoc=NroDoc from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta -- ¿PARA QUE SE PUSO?


  if not exists (select Cd_Pro from Producto where RucE=@RucE and Cd_Pro = @Cd_Pro)
  begin	set @msj = 'Codigo de producto ' +@Cd_Pro+ ' no existe en catalogo' --, en documento ' + @NroDoc
 	rollback transaction
	return
  end

   

  --select  @Cd_CC=Cd_CC, @Cd_SC=Cd_SC, @Cd_SS=Cd_SS from Producto where RucE=@RucE and Cd_Pro = @Cd_Pro
  select  @Cd_CC=Cd_CC, @Cd_SC=Cd_SC, @Cd_SS=Cd_SS from Venta where RucE=@RucE and Cd_Vta = @Cd_Vta


/* VER MAS DESPUES
	if @Cd_CC_Pro = '01010101'
		set @Cd_CC = @Cd_CC_Pro

*/




  insert into VentaDet(RucE,Cd_Vta, Nro_RegVdt,Cd_Pro,Cant,Cd_UM,Valor,DsctoP,DsctoI,IMP,IGV,Total,FecReg,FecMdf,UsuCrea,UsuModf,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10, Cd_CC, Cd_SC, Cd_SS)
                    values(@RucE,@Cd_Vta,dbo.Nro_RegVdt(@RucE,@Cd_Vta),@Cd_Pro,@Cant,@Cd_UM,@Valor,@DsctoP,@DsctoI,@IMP,@IGV,@Total,getdate(),getdate(),@UsuCrea,@UsuCrea,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10, @Cd_CC, @Cd_SC, @Cd_SS)
  if @@rowcount <= 0
  begin
	set @msj = 'Producto no pudo ser registrado'
 	rollback transaction
	return
  end

---
   declare @IB_IncIGV bit, @IB_Exrdo bit, @BIM numeric(13,2), @INF numeric(13,2), @EXO numeric(13,2)
   select @IB_IncIGV=IB_IncIGV, @IB_Exrdo=IB_Exrdo  from Producto where Cd_Pro=@Cd_Pro

   if(@IB_IncIGV=1)
   begin
     set @BIM=@IMP set @INF=0.00 set @EXO=0.00
   end
   else if (@IB_Exrdo=1)
	   begin  set @INF=0.00  set @EXO=@IMP set @BIM=0.00  end
        else begin  set @INF=@IMP  set @EXO=0.00  set @BIM=0.00  end

   --update Venta set BIM=BIM+@BIM, IGV=IGV+@IGV, Total=Total+@Total where RucE = @RucE and Cd_Vta=@Cd_Vta
   update Venta set INF=INF+@INF, EXO=EXO+@EXO, BIM=BIM+@BIM, IGV=IGV+@IGV, Total=Total+@Total where RucE = @RucE and Cd_Vta=@Cd_Vta
---
   
   if @@rowcount <= 0
   begin 
	set @msj = 'Venta no pudo ser actualizada'
 	rollback transaction
	return
   end
   else 
   begin
	set @Ad_INF_Vta = 0.00
	set @Ad_BIM_Vta = 0.00
	set @Ad_IGV_Vta = 0.00
	set @Ad_Total_Vta = 0.00
	select @Ad_INF_Vta= INF+EXO, @Ad_BIM_Vta= BIM, @Ad_IGV_Vta = IGV,  @Ad_Total_Vta = Total from  Venta  where RucE = @RucE and Cd_Vta=@Cd_Vta
   end


   --//ACTUALIZANDO INFORMACION VENTA-RM
   -----------------------------------------------------------------------------------------------------------------------
   declare @NroReg int
   set @NroReg = (select max(NroReg) from VentaRM where  RucE = @RucE and Cd_Vta=@Cd_Vta)
   update VentaRM set Total=Total+@Total where NroReg=@NroReg
   -----------------------------------------------------------------------------------------------------------------------


commit transaction


/*
Prubas consulta:

select * from venta where ruce='11111111111' and RegCtb='VTGE_RV10-00008'
select * from ventaDet where ruce='11111111111' and Cd_vta='VT00000204'
select * from ventaDet where ruce='11111111111' and Cd_vta='VT00000206'

*/


--PV: MIE 07-10-09 --> Creado
--PV: Lun 19/04/2010  Mdf --> Se agregaron Centros de Costo
GO
