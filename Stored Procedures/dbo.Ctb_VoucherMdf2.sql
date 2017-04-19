SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherMdf2]
@RucE nvarchar(11),
@Cd_Vou int,
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_MdRg nvarchar(2),
@CamMda decimal(6,3),
@FecMov smalldatetime,
@RegCtb nvarchar(15),
@Cd_Fte nvarchar(2),
@Cd_Aux nvarchar(7),
@NroCta nvarchar(10),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@IC_TipAfec nvarchar(1),
@Glosa nvarchar(100),
@NroChke varchar(30),
@Cd_TG nvarchar(2),
@MtoD decimal(13,2),
@MtoH decimal(13,2),
@MtoD_ME decimal(13,2),
@MtoH_ME decimal(13,2),
@Cd_Area nvarchar(6),
@UsuModf nvarchar(10),

@FecED smalldatetime,
@FecVD smalldatetime,

@msj varchar(100)output

as

set @msj = 'Para modificar  voucher, debe actualizar el sistema'
/*

if not exists (select * from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou)
	set @msj = 'Voucher no existe'
else
begin
	Declare @Valor nvarchar(15)
	Set @Valor = (select RegCtb from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	print @Valor
	if(@Valor<>@RegCtb)  -- Si RegCtb actual (@valor) es diferente al RegCtb mandado (@RegCtb) -->> se quiere modificar RegCtb 
	begin
		if exists (select RegCtb from Voucher where RucE=@RucE and Ejer=@Ejer and Cd_Vou<>1 and RegCtb=@RegCtb)
		begin
			set @msj = 'Registro Contable ya existe'
			return
		end
	end	

	update Voucher set RegCtb = @RegCtb where RucE=@RucE and Ejer=@Ejer and RegCtb=@Valor

	if @@rowcount <= 0
	   set @msj = 'Registro Contable no pudo ser modificado'

	update Voucher set 
		Ejer = @Ejer,
		Prdo = @Prdo,
		Cd_CC = @Cd_CC,
		Cd_SC = @Cd_SC,
		Cd_SS = @Cd_SS,
		Cd_MdRg = @Cd_MdRg,
		CamMda = @CamMda,
		FecMov = @FecMov,
		--RegCtb = @RegCtb,
		Cd_Fte = @Cd_Fte,
		Cd_Aux = @Cd_Aux,
		NroCta = @NroCta,
		Cd_TD = @Cd_TD,
		NroSre = @NroSre,
		NroDoc = @NroDoc,
		IC_TipAfec = @IC_TipAfec,
		Glosa = @Glosa,
		NroChke = @NroChke,
		Cd_TG = @Cd_TG,
		MtoD = @MtoD,
		MtoH = @MtoH,
		MtoD_ME=@MtoD_ME,
		MtoH_ME=@MtoH_ME,
		Cd_Area = @Cd_Area,
		UsuModf = @UsuModf,
		FecED = @FecED,
		FecVD = @FecVD
	where RucE=@RucE and Cd_Vou = @Cd_Vou
	if @@rowcount <= 0
	   set @msj = 'Voucher no pudo ser modificado'
end
*/

print @msj
-- DIE  16/04/2009 Modificacion para alterar todo los registros contables similares que se localizan dentro de la tabla
-- DIE  08/05/2009 Se agrego los campos FecED y FecVD
-- PV: 23/07/2009 Mdf: faltaba considerar año (@Ejer) para modificar
-- J	23/07/2009 Se agregaron los campos MtoD_ME,MtoH_ME

--PV: Mdf Vie 19/03/2010  ---> inavilitacion SP
GO
