SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec user321.Proc_Transf_Arregla_Cd_Aux_Null '20492595498','2011'
CREATE procedure [user321].[Proc_Transf_Arregla_Cd_Aux_Null]
@RucE nvarchar(11),
@Ejer nvarchar(4) 
As
--set @RucE = '20492595498'
--set @Ejer = '2011'
declare @Var varchar(8000)
set @Var='
declare @Cd_Vou int
declare @Cd_Aux nvarchar(14) 

declare _Cursor cursor for
SELECT 
	Cd_Vou, Cd_Aux 
from 
	OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
	''SELECT 
		 Cd_Vou,Cd_Aux
	  from 
		 dbo.Voucher where RucE='''''+@RucE+''''' and Ejer='''''+@Ejer+''''' '')
where Cd_Vou In(
	select Cd_Vou from Voucher
	where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Cd_Clt is null and Cd_Prv is null and NroCta in 
	(
		select NroCta from PlanCtas 
		where IB_Aux = 1 and RucE='''+@RucE+''' and Ejer='''+@Ejer+'''
	) and (Cd_Aux is null or Cd_Aux = '''')
)

open _Cursor 

Fetch Next FROM _Cursor Into @Cd_Vou, @Cd_Aux
While @@Fetch_status = 0
Begin
	--Print @Cd_Vou
	If(Len(Isnull(@Cd_Aux,'''')) <> 0)
		Update Voucher set Cd_Aux=@Cd_Aux where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Cd_Vou=@Cd_Vou
	Fetch Next FROM _Cursor Into @Cd_Vou, @Cd_Aux
End 

Close _cursor
Deallocate _cursor
'
Print @Var
Exec(@Var)

GO
