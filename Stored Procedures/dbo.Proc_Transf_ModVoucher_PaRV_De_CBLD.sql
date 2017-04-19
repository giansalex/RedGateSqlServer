SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Proc_Transf_ModVoucher_PaRV_De_CBLD]
@RucE nvarchar(11),
@Ejer varchar(4)
AS

declare @Cd_Vou int

declare @Cd_Aux nvarchar(14) 
declare @Auxiliar nvarchar(38) 
declare @sql nvarchar(1000)
declare @sentencia nvarchar(1000)

declare @Cd_TD nvarchar(2)
declare @NroSre nvarchar(4)
declare @NroDoc nvarchar(15)
declare @Cd_FteV varchar(2)
declare @Cd_FteT varchar(2)
declare @Clt_PrvV char(10)

select @Auxiliar = RSocial from Empresa where Ruc = @RucE
print 'Ruc Empresa: ' + @RucE
print 'Nombre Empresa: ' + @Auxiliar
print 'Año: ' + @Ejer
print ''


declare _cursor cursor for
select 
	Cd_VouT As Cd_Vou, Cd_TDT As Cd_TD, NroSreT As NroSre, NroDocT As NroDoc,Cd_FteV,Cd_FteT,
	Clt_PrvV
from( 
	select 
		v.RucE, v.Ejer, v.Cd_Vou As Cd_VouV, t.Cd_Vou As Cd_VouT,
		v.Cd_Fte As Cd_FteV, t.Cd_Fte As Cd_FteT, v.Cd_TD As Cd_TDV,
		v.NroSre As NroSreV, v.NroDoc As NroDocV, t.Cd_TD As Cd_TDT,
		t.NroSre As NroSreT, t.NroDoc As NroDocT,
		Isnull(v.Cd_Clt,v.Cd_Prv) As Clt_PrvV, t.Clt_PrvT, t.Cd_Aux
	from 
		voucher as v
		inner join (
		select	RucE, Ejer, Cd_Vou, Cd_Fte, Isnull(Cd_TD,'') As Cd_TD,
				Isnull(NroSre,'') As NroSre, Isnull(NroDoc,'') As NroDoc,
				Cd_Aux, Isnull(Cd_Clt,Cd_Prv) As Clt_PrvT, Glosa
		from 
			voucher 
		where 
			RucE=@RucE and Ejer=@Ejer and Cd_Fte in('CB','LD')
		) as t on t.RucE=v.RucE and t.Ejer=v.Ejer and t.Cd_TD=v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc=v.NroDoc
	where 
		v.RucE=@RucE and v.Ejer=@Ejer  and Len(v.Cd_TD) <> 0
		and Len(v.NroSre) <> 0 and Len(v.NroDoc) <> 0 and v.Cd_Fte in ('RC','RV')
) as v
where 
	v.Clt_PrvT Is Null and v.Clt_PrvV Is Not Null
Order by
	Cd_TDT, NroSreT, NroDocT
Open _cursor

Fetch Next From _cursor Into @Cd_Vou, @Cd_TD,@NroSre,@NroDoc,@Cd_FteV,@Cd_FteT,@Clt_PrvV
while @@FETCH_STATUS = 0
	Begin
		print Convert(varchar,@Cd_Vou)+' '+@Cd_TD+' '+@NroSre+' '+@NroDoc+' '+@Cd_FteV+' '+@Cd_FteT+' '+@Clt_PrvV
		if(@Cd_FteV='RV')
		Begin
			update 
				Voucher 
			Set 
				Cd_Clt=@Clt_PrvV, 
				Cd_Aux=Null 
			Where 
				RucE=@RucE 
				and Ejer=@Ejer 
				and Cd_Vou=@Cd_Vou
				and Cd_Fte=@Cd_FteT
				and Cd_TD=@Cd_TD
				and NroSre=@NroSre
				and NroDoc=@NroDoc
			print 'a'
		End
		else 
			print 'b'
	Fetch Next From _cursor Into @Cd_Vou, @Cd_TD,@NroSre,@NroDoc,@Cd_FteV,@Cd_FteT,@Clt_PrvV
	End 
Close _cursor
Deallocate _cursor
--exec Proc_Transf_ModVoucher_PaRV_De_CBLD '20522703673','2011'
--select *from Voucher where RucE='20522703673' and Ejer='2011' and Cd_Vou=695
GO
