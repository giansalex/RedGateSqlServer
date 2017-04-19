SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Trans_Mod_CltVdr_VtaCab]
@RucE nvarchar(11),
@Ejer varchar(4)
as


--nuevos--
declare @Cd_Cte_NO nvarchar(7)
declare @Cd_Vdr_NO nvarchar(7)
-----------
declare @Cd_Clt char(10)
declare @Cd_Vdr char(10)

DECLARE _cursor cursor for
		select 
			Cd_Cte_NO,Cd_Vdr_NO 
		from 
			venta 
		where 
			RucE=@RucE 
			and Eje=@Ejer 
		group by
			Cd_Cte_NO,
			Cd_Vdr_NO
		order by  
			Cd_Cte_NO,
			Cd_Vdr_NO
Open _cursor
	Fetch Next From _cursor Into @Cd_Cte_NO, @Cd_Vdr_NO
	While @@Fetch_Status = 0
		Begin
			If(Len(@Cd_Cte_NO) <> 0)
			Begin
				set @Cd_Clt = (Select Cd_Clt from Cliente2 where RucE=@RucE and Cd_Aux=@Cd_Cte_NO)
					If(@Cd_Clt Is Not Null)
					Begin
						print @Cd_Clt
						print @Cd_Cte_NO
						--actualiza cliente
						Update
							Venta
						Set 
							Cd_Clt=@Cd_Clt,
							Cd_Cte_NO=Null
						Where
							RucE=@RucE
							and Eje=@Ejer
							and Cd_Cte_NO=@Cd_Cte_NO
					End
			End
			If(Len(@Cd_Vdr_NO) <> 0)
			Begin
				Set @Cd_Vdr = (Select Cd_Vdr from Vendedor2 where RucE=@RucE and CA10=@Cd_Vdr_NO)
					If(@Cd_Vdr Is Not Null)
					Begin
						Print @Cd_Vdr
						Update 
							Venta
						Set 
							Cd_Vdr=@Cd_Vdr,
							Cd_Vdr_NO=Null
						Where
							RucE=@RucE
							and Eje=@Ejer
							and Cd_Vdr_NO=@Cd_Vdr_NO
					End
			End
		Fetch Next From _cursor Into @Cd_Cte_NO, @Cd_Vdr_NO
		End
Close _cursor
Deallocate _cursor
GO
