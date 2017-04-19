SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_ValidaNroDocC]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TD nvarchar(2),
@NroSre varchar(5),
@NroDoc nvarchar(15),
@Cd_Com char(10) output,
@FecED smalldatetime output,
@msj varchar(100) output
as
if not exists(select * from Compra where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc)
		set @msj = 'No existe ningun documento '+@Cd_TD+' '+@NroSre+'-'+@NroDoc
else	
	declare @n int
	set @n =( select Codigos from 
	(select count(Cd_Com) as Codigos,RucE,Cd_TD,NroSre,NroDoc from Compra where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
	group by RucE,Cd_TD,NroSre,NroDoc) as TCompra)	
	--print @n
	if(@n>1)
		BEGIN
		set @msj = 'Se tienen mas de dos codigos de compra relacionados'
		END
	else
	select @Cd_Com=Cd_Com,@FecED=FecED from Compra where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc

/*else
begin
	select top 1 RucE,Ejer,RegCtb,FecED,Cd_TD,NroSre,NroDoc,'' as FecEDRef,'' as Cd_TDRef,'' as NroSreRef, '' as NroDocRef from voucher
	where RucE=@RucE and Ejer=@Ejer and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
	
end*/
print @msj
print @Cd_Com
print @FecED
--sp_help compra

GO
