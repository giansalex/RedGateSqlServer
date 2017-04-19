SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ModVoucher_PaCBLD_De_RC]
@RucE nvarchar(11),
@Ejer varchar(4)
As

declare @Cd_VouT int
declare @Cd_VouRC int
declare @Cd_Aux nvarchar(7)
declare @Cd_Prv char(7)
declare @Cd_Prv1 char(7)

declare _cursor Cursor For
select 
	v.Cd_Vou as Cd_VouRC,
	t.Cd_Vou as Cd_VouT,
	t.Cd_Aux,
	v.Cd_Prv
from 
	voucher v 
	inner join (
	Select 
		RucE,
		Ejer,
		Cd_Vou,
		RegCtb,
		Cd_Clt,
		Cd_Aux,
		Isnull(Cd_TD,'') Cd_TD,
		Isnull(NroSre,'') NroSre,
		Isnull(NroDoc,'') NroDoc
	From 
		Voucher v
	where 
		RucE=@RucE
		and Ejer=@Ejer
		and Cd_Fte in('CB','LD')
		and Cd_Aux Is Not Null
		and Cd_Prv Is Null
		and Cd_Clt Is null
		and Len(Cd_TD) <>0
		and Len(NroSre) <>0
		and Len(NroDoc) <>0
	) as t on t.RucE=v.RucE and t.Ejer=v.Ejer and t.Cd_TD=v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc=v.NroDoc
Where 
	v.RucE=@RucE
	And v.Ejer=@Ejer
	And v.Cd_Fte='RC'

Open _Cursor

Fetch Next From _cursor Into @Cd_VouRC,@Cd_VouT, @Cd_Aux,@Cd_Prv
	While @@fetch_status = 0 
	Begin
		
		select @Cd_Prv1 = Cd_Prv from Proveedor2 where RucE=@RucE and CA10=@Cd_Aux
		--print @Cd_Prv1
		--print 'CB: '+Convert(varchar,@Cd_VouT)+' RC: '+Convert(varchar,@Cd_VouRC)+' '+@Cd_Aux+' '+Isnull(@Cd_Prv,'Null')
		If(@Cd_Prv1 Is Null)
		Begin 
			--No Existe proveedor
			exec user321.Proc_Transf_Prv_PA_CBLD @RucE, @Cd_Aux, @Cd_Prv1 output
			set @Cd_Prv1=(Select Cd_Prv from Proveedor2 where RucE=@RucE and CA10=@Cd_Aux)
			print 'Ya se Creo'
		End
		--set @Cd_Prv1=(Select Cd_Prv from Proveedor2 where RucE=@RucE and CA10=@Cd_Aux)
		If(@Cd_Prv1 Is not null)
		Begin
			--Existe pero no en CB-LD
			Update 
				Voucher
			Set 
				Cd_Prv=@Cd_Prv1,
				Cd_Aux=Null
			Where
				RucE=@RucE
				and Ejer=@Ejer
				and Cd_Vou=@Cd_VouT
				print 'en cb'
		End
		
		if(@Cd_Prv1 Is not null and @Cd_Prv Is Null) 
		Begin
			Update 
				Voucher
			Set 
				Cd_Prv=@Cd_Prv1,
				Cd_Aux=Null
			Where
				RucE=@RucE
				and Ejer=@Ejer
				and Cd_Vou=@Cd_VouRC
			print 'En RC'
		End
		Fetch Next From _cursor Into @Cd_VouRC,@Cd_VouT, @Cd_Aux,@Cd_Prv
	End
Close _Cursor
deallocate _Cursor
GO
