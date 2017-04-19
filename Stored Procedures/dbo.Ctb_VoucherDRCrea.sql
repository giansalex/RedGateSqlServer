SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherDRCrea]
@RucE nvarchar(11),

@Cd_Vou int,
@FecED smalldatetime,
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from VoucherDR where RucE=@RucE and Cd_Vou=@Cd_Vou)
	set @msj = 'Voucher ya existe'
else
begin
	insert into VoucherDR (RucE,Cd_Vou,FecED,Cd_TD,NroSre,NroDoc)
		  values(@RucE,@Cd_Vou,@FecED,@Cd_TD,@NroSre,@NroDoc)
	
	if @@rowcount <= 0
		set @msj = 'Documento Referencia no pudo ser ingresado'
end
print @msj
GO
