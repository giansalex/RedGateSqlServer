SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_BcoNroCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Itm_BC nvarchar(10),
@NroChke varchar(30),
@msj varchar(100) output
as

	declare @NroCta nvarchar(12)

	select @NroCta = NroCta from Banco where RucE = @RucE and Ejer=@Ejer and Itm_BC = @Itm_BC 

	set @NroChke = (select max(NroChke) from voucher where RucE=@RucE and NroCta=@NroCta and NroChke is not null and Ejer=@Ejer and isnumeric(NroChke)=1 )

	print @NroChke

print @msj


--Pruebas:
--exec dbo.Tsr_BcoNroCons '11111111111','2009','BC00000001',null,null
--exec dbo.Tsr_BcoNroCons '11111111111','2009','BC00000001',null,null

--select * from banco
--select * from voucher where RucE='11111111111' and NroCta='10.4.0.01' and Ejer='2009'
--select * from voucher where RucE='20512635025' and NroCta='10.4.0.01' and NroChke is not null and Ejer='2009'
--select max(NroChke) from voucher where RucE='20512635025' and NroCta='10.4.0.01' and NroChke is not null and Ejer='2009' and isnumeric(NroChke)=1
--select max(NroChke) from voucher where RucE='11111111111' and NroCta='10.4.0.01' and NroChke is not null and Ejer='2009' and isnumeric(NroChke)=1


-- PV : Mar 08/09/2009  -- creado 




GO
