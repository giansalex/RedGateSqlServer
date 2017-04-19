CREATE TABLE [dbo].[TipCamRM]
(
[NroReg] [int] NOT NULL,
[FecTC] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[TCCom] [numeric] (13, 3) NOT NULL,
[TCVta] [numeric] (13, 3) NOT NULL,
[TCPro] [numeric] (13, 3) NOT NULL,
[Usu] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipCamRM] ADD CONSTRAINT [PK_TipCamRM] PRIMARY KEY CLUSTERED  ([NroReg]) ON [PRIMARY]
GO
