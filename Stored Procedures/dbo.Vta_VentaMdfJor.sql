SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaMdfJor]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10), 
@Eje nvarchar(4),
@Prdo nvarchar(2), 
@RegCtb nvarchar(15),
@FecMov smalldatetime,

@Cd_FPC nvarchar(2), 
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@Cd_Sr nvarchar(4),
@Cd_Cte nvarchar(7),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar (2),
@Obs varchar(1000),

@INF numeric(13,2),
@BIM numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@UsuModf nvarchar(10),
--@EXO numeric(13,2),
@msj varchar(100) output

as
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin
	declare @RegCtbAnt nvarchar(15)
	select @RegCtbAnt = RegCtb from Venta  where RucE = @RucE and Cd_Vta = @Cd_Vta

	if(@RegCtbAnt<>@RegCtb)
	begin
		if exists (select * from Venta where RucE=@RucE and RegCtb=@RegCtb and Eje = @Eje)
		begin
			set @msj='Registro Contable ya existe en Ventas'
			return
		end
		if exists (select * from Voucher where RucE=@RucE and Ejer = @Eje and RegCtb=@RegCtb)
		begin
			set @msj='Registro Contable ya existe en Contabilidad'
			return
		end
	end	

	declare @Cd_TDAnt nvarchar(2)
	declare @NroDocAnt nvarchar(15)
	declare @Cd_SrAnt nvarchar(4)
	select @Cd_TDAnt = Cd_TD, @NroDocAnt = NroDoc, @Cd_SrAnt= Cd_Sr from Venta  where RucE = @RucE and Cd_Vta = @Cd_Vta

	if((@Cd_TDAnt <> @Cd_TD) or (@NroDocAnt<>@NroDoc) or (@Cd_Sr <> @Cd_SrAnt))
	begin
		if exists (select * from Venta where RucE=@RucE and Cd_TD=@Cd_TD and isnull(@Cd_Sr,'') = @Cd_Sr and NroDoc=@NroDoc) --and @Cd_Fte!='CB' and @Cd_Fte!='LD'
		begin
			set @msj = 'Ya existe un registro contable con el mismo tipo, serie y nro. de documento.'
			return
		end
		if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(@Cd_Sr,'') = @Cd_Sr and NroDoc=@NroDoc and Cd_Fte='RV') --and @Cd_Fte!='CB' and @Cd_Fte!='LD'
		begin
			set @msj = 'Ya existe un voucher contable con el mismo tipo, serie y nro. de documento.'
			return
		end
	end

	update Venta set 
		Cd_FPC=@Cd_FPC, Cd_Sr=@Cd_Sr, RegCtb=@RegCtb,
		Cd_Cte=@Cd_Cte, Cd_Vdr=@Cd_Vdr, INF=@INF,-- EXO=@EXO,
		BIM=@BIM, IGV=@IGV, TOTAL=@TOTAL, Obs=@Obs,
		Eje=@Eje, Prdo=@Prdo, FecMov=@FecMov,
		Cd_Area=@Cd_Area, Cd_TD=@Cd_TD, NroDoc=@NroDoc,
		Cd_Mda=@Cd_Mda, CamMda=@CamMda, UsuModf=@UsuModf
	where RucE=@RucE and Cd_Vta=@Cd_Vta

	if @@rowcount <= 0
	begin
	   set @msj = 'Venta no pudo ser modificado'
	   return
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'02')
	-----------------------------------------------------------------------------------

end
print @msj

--JD 02/03/09
--JD 06/03/09
-- PP : 2010-08-17 16:50:36.463	 : <Creacion del procedimiento almacenado>
GO
