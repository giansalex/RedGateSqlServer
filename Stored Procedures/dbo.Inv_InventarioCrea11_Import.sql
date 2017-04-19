SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ESTE METODO SOLO DEBE SER USADO CUANDO SE QUIERA GUARDAR COSTOS EN DOLARES Y SOLES
CREATE procedure [dbo].[Inv_InventarioCrea11_Import]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Alm varchar(20),
@Cd_Prod char(7),
@FecMov datetime,
@Cd_TDES char(2),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@Cd_MIS char(3),
@Cd_TO char(2),
@ID_UMP int,
@Cant_Ing numeric(13,3),
@ID_UMBse int,
@Cant numeric(13,3),
@CosUnt numeric(15,7),------------------
@Total numeric(15,7),-------------------
@IC_ES char(1),
@Cd_GR char(10),
@Cd_Vta nvarchar(10),
@Cd_OP char(10),
@Cd_Com char(10),
@Cd_OC char(10),
@Item int,
@RegCtb nvarchar(15),
@Cd_Area nvarchar(6),
@Cd_CC  nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@NroGC varchar(10),
@Cd_Prv varchar(7),
@Cd_Clt varchar(10),
@UsuCrea varchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@IB_EsPrimero bit output,
@Cd_SR char(10),
@Cd_OF char(10),
@msj varchar(100) output,
@Cd_Inv char(12) output,
@Cd_ProdGrp char(7),
@CantGrp numeric(13,3),
@TipNC char(2),
@Cd_Lote char(10)
as

if not exists (select* from Almacen where RucE=@RucE and Cd_Alm=@Cd_Alm) and (isnull(@Cd_Alm,'')<>'')
	begin
		set @msj = 'No existe codigo de Almacen: ' + @Cd_Alm
		return
	end

if not exists (select* from Area where RucE=@RucE and Cd_Area=@Cd_Area) and (isnull(@Cd_Area,'')<>'') --@Cd_Area is not null
	begin
		set @msj = 'No existe codigo de Area: ' + @Cd_Area
		return
	end

 set @msj=dbo.Valida_CentrosDeCosto(@RucE,@Cd_CC,@Cd_SC,@Cd_SS)

if(@msj<>'')
   begin
    return 
   end

   if not exists (select* from TipoOperacion where  Cd_TO=@Cd_TO) and (isnull(@Cd_TO,'')<>'') 
	begin
		set @msj = 'No existe codigo de Tipo Operacion : ' + @Cd_TO
		return
	end

	 if not exists (select* from Producto2 where  RucE=@RucE and Cd_Prod=@Cd_Prod) and (isnull(@Cd_Prod,'')<>'') --@Cd_Prod is not null
	begin
		set @msj = 'No existe codigo de producto : ' + @Cd_Prod
		return
	end
	
	if not exists (select* from Prod_UM where  RucE=@RucE and ID_UMP =@ID_UMP) and (isnull(@ID_UMP,'')<>'')--@ID_UMP is not null
	begin
		set @msj = 'No existe codigo UM de producto  : ' + @ID_UMP
		return
	end

	if not exists (select* from Moneda where Cd_Mda =@Cd_Mda) and   (isnull(@Cd_Mda,'')<>'')--@Cd_Mda is not null
	begin
		set @msj = 'No existe codigo Moneda  : ' + @Cd_Mda
		return
	end
	




if @IB_EsPrimero=1 and exists (select * from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
begin
	set @msj = 'Ya existe un Mov. de Inventario con este registro contable: ' + @RegCtb
	return
end

declare @CosUnt_ME numeric(15,7)
declare @Total_ME numeric(15,7)

if exists (select * from Prod_UM where Cd_Prod = @Cd_Prod and Factor = '1' and RucE = @rucE)
	select @ID_UMBse = MIN( ID_UMP) from Prod_UM where Cd_Prod = @Cd_Prod and Factor = '1' and RucE = @RucE
else
	set @ID_UMBse = @ID_UMP
set @Cant = (select Factor from Prod_UM where Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and RucE = @RucE)*@Cant_Ing
if @IC_ES = 'S'
begin
	set @Cant_Ing = 0-@Cant_Ing
	set @Cant = 0-@Cant
	select top 1 
	@CosUnt = CProm, 
	@CosUnt_ME = CProm_ME, 
	@Total = CProm * @Cant, 
	@Total_ME = CProm_ME * @Cant
	from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov <=@FecMov order by FecMov  desc, Cd_Inv desc
end
else
begin
--POR EL MOMENTO -- UNA SOLA COLUMNA
	if (@Cd_Mda = '01')
	begin
		set @Total_ME = case(@Total) when 0 then 0 else @Total/@CamMda end
		set @CosUnt = case(@Cant) when 0 then 0 else ( case(@Total) when 0 then 0 else @Total / @Cant end ) end
		set @CosUnt_ME = case(@CosUnt) when 0 then 0 else @CosUnt/@CamMda end
	end
	else
	begin
		set @Total_ME = @Total		
		set @Total = @Total_ME*@CamMda
		set @CosUnt_ME = case(@Cant) when 0 then 0 else ( case(@Total_ME) when 0 then 0 else @Total_ME / @Cant end ) end
		set @CosUnt = @CosUnt_ME*@CamMda
	end
end
declare @SCant numeric(13,3)
declare @CProm numeric(15,7)
declare @SCT numeric(15,7)
declare @CProm_ME numeric(15,7)
declare @SCT_ME numeric(15,7)
select top 1 
	@SCant = SCant + @Cant, 
	@SCT = SCT+ @Total, 
	@SCT_ME = SCT_ME+ @Total_ME 
	from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov <=@FecMov order by FecMov  desc, Cd_Inv desc
set @Scant = isnull(@SCant, @Cant)
set @SCT = isnull(@SCT, @Total)
set @SCT_ME = isnull(@SCT_ME, @Total_ME)
if(@SCant =0)
begin
	set @SCT = 0
	set @SCT_ME = 0
	set @CProm = 0
end
else
begin
	set @CProm = @SCT/@SCant
	set @CProm_ME = @SCT_ME/@SCant
end
set @Cd_Inv = dbo.Cd_Inv(@RucE)
insert into Inventario (RucE,Cd_Inv,Ejer,Cd_Alm,Cd_Prod,FecMov,Cd_TDES,Cd_TD,NroSre,NroDoc,Cd_TO,ID_UMP,Cant_Ing ,ID_UMBse,Cant,CosUnt,Total,IC_ES,SCant,CProm,SCT,Cd_GR,Cd_Vta,Cd_OP,Cd_Com,Cd_OC,Item,RegCtb,Cd_MIS,Cd_Area,Cd_CC,Cd_SC,Cd_SS,NroGC,Cd_Prv,Cd_Clt,FecReg,UsuCrea,CA01,CA02,CA03,CA04,CA05,Cd_Mda,CamMda, Cd_SR, Cd_OF,CosUnt_ME,Total_ME,CProm_ME, SCT_ME, Cd_ProdGrp, CantGrp, TipNC,Cd_Lote)
	values (@RucE,@Cd_Inv,@Ejer,@Cd_Alm,@Cd_Prod,@FecMov,@Cd_TDES,@Cd_TD,@NroSre,@NroDoc,@Cd_TO,@ID_UMP,@Cant_Ing,@ID_UMBse,@Cant,@CosUnt,@Total,@IC_ES,@SCant,@CProm,@SCT,@Cd_GR,@Cd_Vta,@Cd_OP,@Cd_Com,@Cd_OC,@Item,@RegCtb,@Cd_MIS,@Cd_Area,@Cd_CC,@Cd_SC,@Cd_SS,@NroGC,@Cd_Prv,@Cd_Clt,getdate(),@UsuCrea,@CA01,@CA02,@CA03,@CA04,@CA05,@Cd_Mda,@CamMda, @Cd_SR, @Cd_OF,@CosUnt_ME,@Total_ME,@CProm_ME,@SCT_ME,@Cd_ProdGrp,@CantGrp,@TipNC,@Cd_Lote)

if @@rowcount <= 0
	set @msj = 'Inventario no pudo ser registrado.'	


set @IB_EsPrimero = 0

print @msj

-- Leyenda --
-- CAM 04/07/2011 <CREACION DEL SP><SE AGREGARON COLUMNAS PARA LOS COSTOS EN MONEDA EXTRANJERA>
-- PP 06/07/2011 <CREACION DEL SP><SE Se recalculo adecuadamente  la Moneda Extranjera
-- CAM 30/06/2012 <MDF DEL SP><SE AUMENTO A 7 DECIMALES TODAS LAS COSTOS>
-- CAM 11/08/2012 <MDF del dp><se agrego cd_Lote>
GO
