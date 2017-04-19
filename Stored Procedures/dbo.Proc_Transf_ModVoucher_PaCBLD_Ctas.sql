SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec Proc_Transf_ModVoucher_PaRV_De_CBLD '10072636959', '2008'
--exec Proc_Transf_ModVoucher_PaRV_De_CBLD '10072636959', '2009'
--exec Proc_Transf_ModVoucher_PaCBLD_De_RC '10072636959', '2008'
--exec Proc_Transf_ModVoucher_PaCBLD_De_RC '10072636959', '2009'
--exec Proc_Transf_ModVoucher_PaCBLD_Ctas '10072636959','2008'

CREATE procedure [dbo].[Proc_Transf_ModVoucher_PaCBLD_Ctas]
@RucE nvarchar(11),
@Ejer varchar(4)
As

declare @Cd_VouT int
declare @Cd_Aux nvarchar(7)
declare @Cd_Prv1 char(7)
declare @NroCta nvarchar(10)


declare _Cursor cursor for
	Select 
		Cd_Vou,
		Cd_Aux,
		NroCta
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
Open _Cursor

Fetch next from _Cursor into @Cd_VouT, @Cd_Aux,@NroCta
While @@fetch_status = 0 
Begin
	if(@NroCta like '42%')
	Begin
		set @Cd_Prv1=(Select Cd_Prv from proveedor2 where RucE=@RucE and CA10=@Cd_Aux)
		if(ISNULL(@Cd_Prv1,'')='')
		Begin
			print 'hay q crear'
			exec user321.Proc_Transf_Prv_PA_CBLD @RucE,@Cd_Aux,@Cd_Prv1 output
		End
		
	End
	else print 'a'+@NroCta
	
	if(@Cd_Prv1 is not null)
	Begin 
		Update
			Voucher
		set
			Cd_Prv=@Cd_Prv1,
			Cd_Aux=Null
		Where
			RucE=@RucE
			and Ejer=@Ejer
			and Cd_Vou=@Cd_VouT
	End
	else print 'sin proveedor'
 Fetch Next From _cursor Into @Cd_VouT, @Cd_Aux,@NroCta
End
Close _Cursor
deallocate _Cursor

GO
