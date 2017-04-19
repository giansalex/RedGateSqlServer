CREATE TABLE [dbo].[VoucherDR]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vou] [int] NOT NULL,
[FecED] [smalldatetime] NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DR_CdVou] [int] NULL,
[DR_CdTD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DR_FecED] [smalldatetime] NULL,
[DR_NSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoucherDR] ADD CONSTRAINT [PK_VoucherDocRef] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vou]) ON [PRIMARY]
GO
