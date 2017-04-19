SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionDetCrea]

@RucE	nvarchar(11),
@Cd_IP	char(7),
@Item int output,
@Cd_Prod char(7),
@ID_UMP int,
@Cd_Com char(10),
@ItemCP int, 
@Cant numeric(13,3),
@PesoKg numeric (18,3),
@Volumen numeric (18,3),
@EXW numeric (18,4),
@Com numeric (18,4),
@OtroE numeric (18,4),
@FOB numeric (18,4),
@Flete numeric (18,4),
@Seg numeric (18,4),
@OtroF numeric (18,4),
@CIF numeric (18,4),
@Adv numeric (18,4),
@OtroC numeric (18,4),
@Total numeric (18,4),
@CU numeric (18,4),
@Ratio numeric (18,4),
@EXW_ME numeric (18,4),
@Com_ME numeric (18,4),
@OtroE_ME numeric (18,4),
@FOB_ME numeric (18,4),
@Flete_ME numeric (18,4),
@Seg_ME numeric (18,4),
@OtroF_ME numeric (18,4),
@CIF_ME numeric (18,4),
@Adv_ME numeric (18,4),
@OtroC_ME numeric (18,4),
@Total_ME numeric (18,4),
@CU_ME numeric (18,4),
@Ratio_ME numeric (18,4),
@msj varchar(100) output
as

set @Item = dbo.ItemIP(@RucE, @Cd_IP)
insert into ImportacionDet (RucE,Cd_IP,Item,Cd_Prod,ID_UMP,Cd_Com,ItemCP,Cant,PesoKg,Volumen,EXW,Com,OtroE,FOB,Flete,Seg,OtroF,CIF,Adv,OtroC,Total,CU,Ratio,EXW_ME,Com_ME,OtroE_ME,FOB_ME,Flete_ME,Seg_ME,OtroF_ME,CIF_ME,Adv_ME,OtroC_ME,Total_ME,CU_ME,Ratio_ME)
values (@RucE,@Cd_IP,@Item,@Cd_Prod,@ID_UMP,@Cd_Com,@ItemCP,@Cant,@PesoKg,@Volumen,@EXW,@Com,@OtroE,@FOB,@Flete,@Seg,@OtroF,@CIF,@Adv,@OtroC,@Total,@CU,@Ratio,@EXW_ME,@Com_ME,@OtroE_ME,@FOB_ME,@Flete_ME,@Seg_ME,@OtroF_ME,@CIF_ME,@Adv_ME,@OtroC_ME,@Total_ME,@CU_ME,@Ratio_ME)
if @@rowcount <= 0
	set @msj = 'el detalle de la Importacion no pudo ser registrado'	
GO
